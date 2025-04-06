{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.declarative-jellyfin;
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

            genUser = index: user: let
              values =
                builtins.mapAttrs
                (name: value:
                  if (isBool value)
                  then
                    if value
                    then "1"
                    else "0"
                  else if (isNull value)
                  then "NULL"
                  else value)
                (user
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
                      else "$(${self.packages.${pkgs.system}.genhash}/bin/genhash -k \"${user.Password}\" -i 210000 -l 128 -u)";
                  });
            in
              /*
              bash
              */
              ''
                if [ -n $(${sq} "SELECT 1 FROM Users WHERE Username = '${user.Username}'") ]; then
                  # Create user
                    ${sq} "INSERT INTO Users (${concatStringsSep ","
                  (
                    builtins.filter (x: x != "HashedPasswordFile")
                    (lib.attrsets.mapAttrsToList (name: value: "${name}")
                      ((import ./options/users.nix {inherit lib;}).options.services.declarative-jellyfin.Users.type.getSubOptions []))
                  )}) \\
                    VALUES(${concatStringsSep "," (map toString (builtins.attrValues values))})"
                fi
              '';
          in
            /*
            bash
            */
            ''
              mkdir -p ${path}
              # Make sure there is a database
              if [ ! -e "${path}/${dbname}" ]; then
                cp ${defaultDB} "${path}/${dbname}"
                chmod 770 "${path}/${dbname}"
              fi

              maxIndex=$(${sq} 'SELECT InternalId FROM Users ORDER BY InternalId DESC LIMIT 1')
              if [ -z "$maxIndex" ]; then
                maxIndex="1"
              fi

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
    };
}
