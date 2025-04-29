{
  config,
  lib,
  pkgs,
  self,
  ...
}:
with lib; let
  cfg = config.services.declarative-jellyfin;
  genhash = import ./pbkdf2-sha512.nix {inherit pkgs;};
  toXml' = (import ../lib {nixpkgs = pkgs;}).toXMLGeneric;
  isStrList = x: all (x: isString x) x;
  prepass = x:
    if (isAttrs x)
    then
      if !(hasAttr "tag" x)
      then
        attrsets.mapAttrsToList
        (tag: value: {
          inherit tag;
          content = prepass value;
        })
        x
      else if (hasAttr "content" x)
      then {
        tag = x.tag;
        content = prepass x.content;
      }
      else x
    else if (isList x)
    then
      if (isStrList x)
      then
        (map
          (content: {
            tag = "string";
            inherit content;
          })
          x)
      else map prepass x
    else x;

  toXml = tag: x: (toXml' {
    inherit tag;
    attrib = {
      "xmlns:xsi" = "http://www.w3.org/2001/XMLSchema-instance";
      "xmlns:xsd" = "http://www.w3.org/2001/XMLSchema";
    };
    content = prepass x;
  });
in {
  imports = [
    ./options
  ];
  config =
    mkIf cfg.enable
    {
      system.activationScripts = {
        link-config-xml =
          lib.stringAfter ["var"]
          (
            let
              commands =
                concatStringsSep "\n"
                (map
                  (x: "test ! -e \"/var/lib/jellyfin/config/${x.file}\" && cp -s \"${pkgs.writeText x.file (toXml x.name x.content)}\" \"/var/lib/jellyfin/config/${x.file}\"")
                  [
                    {
                      name = "NetworkConfiguration";
                      file = "network.xml";
                      content = cfg.network;
                    }
                    {
                      name = "EncodingOptions";
                      file = "encoding.xml";
                      content = cfg.encoding;
                    }
                    {
                      name = "ServerConfiguration";
                      file = "system.xml";
                      content = cfg.system;
                    }
                  ]);
            in ''
              mkdir -p "/var/lib/jellyfin/config"
              ${commands}
            ''
          );

        create-db = lib.stringAfter ["var"] (
          let
            dbname = "jellyfin.db";
            defaultDB = ./default.db;
            sq = "${pkgs.sqlite}/bin/sqlite3 \"${path}/${dbname}\" --";
            path = "/var/lib/jellyfin/data";
            options = lib.attrsets.mapAttrsToList (key: value: "${key}") (
              builtins.removeAttrs (
                (import ./options/users.nix {inherit lib;}).options.services.declarative-jellyfin.Users.type.getSubOptions []
              )
              ["HashedPasswordFile" "_module"]
            );

            subtitleModes = {
              Default = 0;
              Always = 1;
              OnlyForce = 2;
              None = 3;
              Smart = 4;
            };

            genUser = index: user: let
              values = builtins.removeAttrs (
                builtins.mapAttrs
                (
                  name: value:
                    if (isBool value) # bool -> 1 or 0
                    then
                      if value
                      then "1"
                      else "0"
                    else if (isNull value) # null -> NULL
                    then "NULL"
                    else if (name == "SubtitleMode") # SubtitleMode -> 0 | 1 | 2 | 3 | 4
                    then subtitleModes.${value}
                    else if (isString value)
                    then "'${value}'"
                    else value
                ) (
                  user
                  // {
                    Id =
                      if !(isNull user.Id)
                      then user.Id
                      else "$(${pkgs.libuuid}/bin/uuidgen | ${pkgs.coreutils}/bin/tr '[:lower:]' '[:upper:]')";
                    InternalId =
                      if !(isNull user.InternalId)
                      then user.InternalId
                      else "$(($maxIndex+${toString (index + 1)}))";
                    Password =
                      if !(isNull user.HashedPasswordFile)
                      then "$(${pkgs.coreutils}/bin/cat \"${user.HashedPasswordFile}\")"
                      else "$(${genhash}/bin/genhash -k \"${user.Password}\" -i 210000 -l 128 -u)";
                  }
                )
              ) ["HashedPasswordFile"];
            in
              /*
              bash
              */
              ''
                if [ -n $(${sq} "SELECT 1 FROM Users WHERE Username = '${user.Username}'") ]; then
                  echo "User doesn't exist. creaing new: ${user.Username}" >> /var/log/log.txt
                  # Create user
                  sql="
                    INSERT INTO Users (${concatStringsSep "," options}) VALUES(${concatStringsSep "," (map toString (builtins.attrValues values))})"

                  echo "SQL COMMAND: $sql" >> /var/log/log.txt
                  res=$(${sq} "$sql")
                  echo "OUT: $res" >> /var/log/log.txt
                fi
              '';
          in
            /*
            bash
            */
            ''
              mkdir -p /var/log
              file /var/log/log.txt

              mkdir -p ${path}
              # Make sure there is a database
              if [ ! -e "${path}/${dbname}" ]; then
                echo "No DB found. Copying default..." >> /var/log/log.txt
                cp ${defaultDB} "${path}/${dbname}"
                chmod 770 "${path}/${dbname}"
              fi

              maxIndex=$(${sq} 'SELECT InternalId FROM Users ORDER BY InternalId DESC LIMIT 1')
              if [ -z "$maxIndex" ]; then
                maxIndex="1"
              fi
              echo "Max index: $maxIndex" >> /var/log/log.txt

              ${
                concatStringsSep "\n"
                (
                  map ({
                    fst,
                    snd,
                  }:
                    genUser snd fst)
                  (
                    lib.lists.zipLists cfg.Users
                    (
                      builtins.genList (x: x)
                      (builtins.length cfg.Users)
                    )
                  )
                )
              }
            ''
        );
      };
      assertions = [
        # Make sure that either Password or HashPasswordFile is provided
        {
          assertion =
            lib.lists.all
            (user: user.HashedPasswordFile != null || user.Password != null)
            cfg.Users;
          message = "Must Provide either Password or HashedPasswordFile";
        }
        # Make sure not both Password and HashPasswordFile is set
        {
          assertion =
            lib.lists.all
            (user: !(user.HashedPasswordFile != null && user.Password != null))
            cfg.Users;
          message = "Can not set both Password and HashedPasswordFile";
        }
        # Check if username provided
        {
          assertion =
            lib.lists.all
            (user: !(isNull user.Username))
            cfg.Users;
          message = "Must set a username for user";
        }
      ];
    };
}
