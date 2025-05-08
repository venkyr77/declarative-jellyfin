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
  log = "/var/log/log.txt";
  print = msg: ''echo "${msg}" | tee --append ${log}'';
  jellyfin-exec = "${getExe config.services.jellyfin.package} --datadir '${config.services.jellyfin.dataDir}' --configdir '${config.services.jellyfin.configDir}' --cachedir '${config.services.jellyfin.cacheDir}' --logdir '${config.services.jellyfin.logDir}'";
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
                (x: ''cp -f "${pkgs.writeText x.file (toXml x.name x.content)}" "${config.services.jellyfin.configDir}/${x.file}"'')
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
            mkdir -p "${config.services.jellyfin.configDir}"
            mkdir -p "${config.services.jellyfin.logDir}"
            mkdir -p "${config.services.jellyfin.dataDir}/metadata"
            mkdir -p "${config.services.jellyfin.dataDir}/wwwroot"
            mkdir -p "${config.services.jellyfin.dataDir}/plugins/configurations"
            ${commands}
            chown -R ${config.services.jellyfin.user}:${config.services.jellyfin.group} "${config.services.jellyfin.dataDir}"
            chmod -R 750 "${config.services.jellyfin.dataDir}"
          ''
        );

      system.activationScripts.create-db = lib.stringAfter ["var"] (
        let
          # See: https://github.com/jellyfin/jellyfin/blob/master/src/Jellyfin.Database/Jellyfin.Database.Implementations/Enums/PermissionKind.cs#L6
          permissionKindToDBInteger = {
            IsAdministrator = 0;
            IsHidden = 1;
            IsDisabled = 2;
            EnableSharedDeviceControl = 3;
            EnableRemoteAccess = 4;
            EnableLiveTvManagement = 5;
            EnableLiveTvAccess = 6;
            EnableMediaPlayback = 7;
            EnableAudioPlaybackTranscoding = 8;
            EnableVideoPlaybackTranscoding = 9;
            EnableContentDeletion = 10;
            EnableContentDownloading = 11;
            EnableSyncTranscoding = 12;
            EnableMediaConversion = 13;
            EnableAllDevices = 14;
            EnableAllChannels = 15;
            EnableAllFolders = 16;
            EnablePublicSharing = 17;
            EnableRemoteControlOfOtherUsers = 18;
            EnablePlaybackRemuxing = 19;
            ForceRemoteSourceTranscoding = 20;
            EnableCollectionManagement = 21;
            EnableSubtitleManagement = 22;
            EnableLyricManagement = 23;
          };
          subtitleModes = {
            Default = 0;
            Always = 1;
            OnlyForce = 2;
            None = 3;
            Smart = 4;
          };
          dbname = "jellyfin.db";
          nonDBOptions = ["HashedPasswordFile" "Mutable" "Permissions" "_module"];
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
                # FIXME: do the same for useridx (InternalId)
                sql="REPLACE INTO Users (${concatStringsSep "," options}) VALUES(${concatStringsSep "," (map toString (attrValues (sqliteFormat mutatedUser)))})"
                if [ -n "$userExists" ]; then
                  ${print "Excluding insertion of UserId, since user already exists in DB"}
                  sql="REPLACE INTO Users (${concatStringsSep "," (lib.lists.remove "UserId" options)}) VALUES(${concatStringsSep "," (map toString (attrValues (sqliteFormat (removeAttrs mutatedUser ["UserId"]))))})"
                fi
                ${print "SQL COMMAND: $sql"}
                res=$(${sq} "$sql")
                ${print "SQL OUTPUT: $res"}

                # Handle user permissions
                ${concatStringsSep "\n" (lib.attrsets.mapAttrsToList (
                  permission: enabled:
                  /*
                  bash
                  */
                  ''
                    userId=$(${sq} "SELECT Id FROM Users WHERE Username = '${mutatedUser.Username}'")
                    sql="REPLACE INTO Permissions (Kind, Value, UserId, Permission_Permissions_Guid, RowVersion) VALUES(${toString permissionKindToDBInteger.${permission}}, ${
                      if enabled
                      then "1"
                      else "0"
                    }, $(echo "'$userId'"), NULL, 0)"
                    ${print "SQL COMMAND: $sql"}
                    ${sq} "$sql"
                  ''
                )
                userOpts.Permissions)}
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

      systemd.services.jellyfin.serviceConfig.ExecStart = lib.mkForce "${
        pkgs.writeShellScriptBin "jellyfin-start"
        /*
        bash
        */
        ''
          # We need to generate a valid migrations.xml file if it's a first run and
          # `services.declarative-jellyfin.system.IsStartupWizardCompleted=true`
          # otherwise jellyfin will try and run deprecated/old migrations, see:
          # https://github.com/jellyfin/jellyfin/issues/12254
            ${
            if (cfg.system.IsStartupWizardCompleted)
            then
              /*
              bash
              */
              ''
                if [ ! -f "${config.services.jellyfin.configDir}/migrations.xml" ]; then
                  echo "First time run and no migrations.xml. We run jellyfin once to generate it..."
                  echo "Starting jellyfin with IsStartupWizardCompleted = false"
                  ${pkgs.xmlstarlet}/bin/xmlstarlet ed -L -u "//IsStartupWizardCompleted" -v "false" "${config.services.jellyfin.configDir}/system.xml"
                  ${jellyfin-exec} & disown
                  echo "Waiting for jellyfin to generate migrations.xml"
                  until [ -f "${config.services.jellyfin.configDir}/migrations.xml" ]
                  do
                    printf "."
                    sleep 1
                  done
                  sleep 1
                  echo "migrations.xml generated! Restarting jellyfin..."
                  echo "migrations.xml:"
                  cat "${config.services.jellyfin.configDir}/migrations.xml"
                  ${pkgs.procps}/bin/pkill -15 -f ${config.services.jellyfin.package}
                  echo "Waiting for jellyfin to shut down properly"
                  while ${pkgs.ps}/bin/ps axg | ${pkgs.gnugrep}/bin/grep -vw grep | ${pkgs.gnugrep}/bin/grep -w ${config.services.jellyfin.package} > /dev/null; do sleep 1 && printf "."; done
                  echo "Jellyfin terminated. Resetting with IsStartupWizardCompleted set to true"
                  ${pkgs.xmlstarlet}/bin/xmlstarlet ed -L -u "//IsStartupWizardCompleted" -v "true" "${config.services.jellyfin.configDir}/system.xml"
                fi
              ''
            else ""
          }

          # MAIN JELLYFIN START
          ${jellyfin-exec}
        ''
      }/bin/jellyfin-start";
    };
}
