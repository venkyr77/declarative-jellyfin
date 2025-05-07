{
  config,
  lib,
  pkgs,
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
  config =
    mkIf cfg.enable
    {
      system.activationScripts.link-config-xml =
        lib.stringAfter ["var"]
        (
          let
            commands =
              concatStringsSep "\n"
              (map
                (x: "cp \"${pkgs.writeText x.file (toXml x.name x.content)}\" \"/var/lib/jellyfin/config/${x.file}\"")
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
            chown -R ${config.services.jellyfin.user}:${config.services.jellyfin.group} "/var/lib/jellyfin/config"
            chmod -R 750 "/var/lib/jellyfin/config"
          ''
        );

      system.activationScripts.create-db = lib.stringAfter ["var"] (
        let
          subtitleModes = {
            Default = 0;
            Always = 1;
            OnlyForce = 2;
            None = 3;
            Smart = 4;
          };
          dbname = "jellyfin.db";
          nonDBOptions = ["HashedPasswordFile" "Mutable" "_module"];
          defaultDB = ./default.db;
          sq = "${pkgs.sqlite}/bin/sqlite3 \"${path}/${dbname}\" --";
          path = "/var/lib/jellyfin/data";
          options = lib.attrsets.mapAttrsToList (key: value: "${key}") (
            (builtins.removeAttrs
              (
                (import ./options/users.nix {inherit lib;}).options.services.declarative-jellyfin.Users.type.getSubOptions []
              )
              nonDBOptions)
            // {Username = null;}
          );
          log = "/var/log/log.txt";
          print = msg: ''echo "${msg}" >> ${log}; echo "${msg}" > /dev/kmsg'';

          sqliteFormat = attrset:
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
            )
            attrset;

          genUser = index: username: userOpts: let
            mutatedUser =
              builtins.removeAttrs
              (userOpts
                // {
                  Username = username;
                  Id =
                    if !(isNull userOpts.Id)
                    then userOpts.Id
                    else "$(${pkgs.libuuid}/bin/uuidgen | ${pkgs.coreutils}/bin/tr '[:lower:]' '[:upper:]')";
                  InternalId =
                    if !(isNull userOpts.InternalId)
                    then userOpts.InternalId
                    else "$(($maxIndex+${toString (index + 1)}))";
                  Password =
                    if !(isNull userOpts.HashedPasswordFile)
                    then "$(${pkgs.coreutils}/bin/cat \"${userOpts.HashedPasswordFile}\")"
                    else "$(${genhash}/bin/genhash -k \"${userOpts.Password}\" -i 210000 -l 128 -u)";
                })
              nonDBOptions;
            #values = concatStringsSep "," (map toString (builtins.attrValues (sqliteFormat mutatedUser)));
          in
            /*
            bash
            */
            ''
              userExists=$(${sq} "SELECT 1 FROM Users WHERE Username = '${mutatedUser.Username}'")
              # If the user is mutable, only insert the user if it doesn't already exist, otherwise just overwrite
              if [ ${
                if (userOpts.Mutable)
                then "-z $userExists" # user doesn't exist
                else "-n \"true\""
              } ]; then
                # User already exists - don't insert a new userID, just re-use the one already present,
                # so any foreign key relations don't fail because of overwriting with newly generated ID.
                sql="REPLACE INTO Users (${concatStringsSep "," options}) VALUES(${concatStringsSep "," (map toString (attrValues (sqliteFormat mutatedUser)))})"
                if [ -n "$userExists" ]; then
                  ${print "Excluding insertion of UserId, since user already exists in DB"}
                  sql="REPLACE INTO Users (${concatStringsSep "," (lib.lists.remove "UserId" options)}) VALUES(${concatStringsSep "," (map toString (attrValues (sqliteFormat (removeAttrs mutatedUser ["UserId"]))))})"
                fi
                ${print "SQL COMMAND: $sql"}
                res=$(${sq} "$sql")
                # ${print "SQL OUTPUT: $res"}
              fi
            '';
        in
          /*
          bash
          */
          ''
            mkdir -p /var/log
            touch /var/log/log.txt

            mkdir -p ${path}
            # Make sure there is a database
            if [ ! -e "${path}/${dbname}" ]; then
              ${print "No DB found. Copying default..."}
              cp ${defaultDB} "${path}/${dbname}"
            fi

            chown -R ${config.services.jellyfin.user}:${config.services.jellyfin.group} "${path}"
            chmod -R 750 "${path}"

            # TODO: Backup database

            # TODO: if mutableUsers = false, then clear Users table

            maxIndex=$(${sq} 'SELECT InternalId FROM Users ORDER BY InternalId DESC LIMIT 1')
            if [ -z "$maxIndex" ]; then
              maxIndex="1"
            fi
            ${print "Max index: $maxIndex"}

            ${
              concatStringsSep "\n"
              (
                map ({
                  fst,
                  snd,
                }:
                  genUser fst snd cfg.Users.${snd})
                (
                  lib.lists.zipLists
                  (
                    builtins.genList (x: x)
                    (builtins.length (builtins.attrValues cfg.Users))
                  )
                  (builtins.attrNames cfg.Users)
                )
              )
            }
          ''
      );
    };
}
