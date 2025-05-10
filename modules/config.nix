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
  jellyfinConfigFiles = {
    "network.xml" = {
      name = "NetworkConfiguration";
      content = cfg.network;
    };
    "encoding.xml" = {
      name = "EncodingOptions";
      content = cfg.encoding;
    };
    "system.xml" = {
      name = "ServerConfiguration";
      content = cfg.system;
    };
  };
  jellyfinDerivations = mapAttrs (file: cfg: pkgs.writeText file (toXml cfg.name cfg.content)) jellyfinConfigFiles;
  # jellyfinDeriviations = map (config: nameValuePair config.file (pkgs.writeText config.file (toXml config.name config.content))) jellyfinConfigFiles;
  jellyfin-exec = "${getExe config.services.jellyfin.package} --datadir '${config.services.jellyfin.dataDir}' --configdir '${config.services.jellyfin.configDir}' --cachedir '${config.services.jellyfin.cacheDir}' --logdir '${config.services.jellyfin.logDir}'";
in {
  config =
    mkIf cfg.enable
    {
      system.activationScripts.link-config-xml =
        lib.stringAfter ["var"]
        (
          let
            configCopyCommands = concatStringsSep "\n" (mapAttrsToList (file: path: ''cp -f "${path}" "${config.services.jellyfin.configDir}/${file}"'') jellyfinDerivations);
          in ''
            mkdir -p "${config.services.jellyfin.configDir}"
            mkdir -p "${config.services.jellyfin.logDir}"
            mkdir -p "${config.services.jellyfin.dataDir}/metadata"
            mkdir -p "${config.services.jellyfin.dataDir}/playlists"
            mkdir -p "${config.services.jellyfin.dataDir}/wwwroot"
            mkdir -p "${config.services.jellyfin.dataDir}/plugins/configurations"
            ${configCopyCommands}
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

          sqliteFormat = key: value:
            if (isBool value) # bool -> 1 or 0
            then
              if value
              then "1"
              else "0"
            else if (isNull value) # null -> NULL
            then "NULL"
            else if (key == "SubtitleMode") # SubtitleMode -> 0 | 1 | 2 | 3 | 4
            then subtitleModes.${value}
            else if (isString value)
            then "'${value}'"
            else value;
          sqliteFormatAttrs = attrset:
            builtins.mapAttrs
            (
              name: value: sqliteFormat name value
            )
            attrset;

          optionsNoId = lib.lists.remove "Id" (lib.lists.remove "InternalId" options);
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
            userWithNoId = removeAttrs mutatedUser ["Id" "InternalId"];
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
                sql="INSERT INTO Users (${concatStringsSep "," options}) VALUES(${concatStringsSep "," (map toString (attrValues (sqliteFormatAttrs mutatedUser)))})"
                # User already exists - don't insert a new Id, just re-use the one already present,
                # so any foreign key relations don't fail because of overwriting with newly generated ID.
                if [ -n "$userExists" ]; then
                  ${print "Excluding insertion of Id/InternalId, since user already exists in DB"}
                   sql="UPDATE Users SET ${concatStringsSep ",\n" (map (
                  {
                    fst,
                    snd,
                  }:
                  /*
                  bash
                  */
                  ''${fst} = ${toString (sqliteFormat fst snd)}''
                )
                (lib.lists.zipLists
                  optionsNoId
                  (attrValues userWithNoId)))} WHERE Username = '${mutatedUser.Username}'"
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

            # Restart jellyfin if running
            if ${pkgs.systemd}/bin/systemctl is-active --quiet jellyfin.service; then
              echo "Restarting jellyfin.service"
              ${pkgs.systemd}/bin/systemctl restart jellyfin.service
            fi
          ''
      );

      system.activationScripts.create-libraries = lib.stringAfter ["var"] (
        let
          # This needs to convert the `options` structure of
          #
          # TypeOptions
          # ├── Series
          # │   ├── MetadataFetchers
          # │   └── ImageFetchers
          # ├── Season
          # │   ├── MetadataFetchers
          # │   └── ImageFetchers
          # └── Episode
          #     ├── MetadataFetchers
          #     └── ImageFetchers
          #
          # To the expected structure in the file of
          #
          # TypeOptions
          # ├── TypeOptions
          # │   ├── Type Series
          # │   ├── MetadataFetchers
          # │   ├── MetadataFetcherOrder
          # │   ├── ImageFetchers
          # │   └── ImageFetcherOrder
          # ├── TypeOptions
          # │   ├── Type Season
          # │   ├── MetadataFetchers
          # │   ├── MetadataFetcherOrder
          # │   ├── ImageFetchers
          # │   └── ImageFetcherOrder
          # └── TypeOptions
          #     ├── Type Episode
          #     ├── MetadataFetchers
          #     ├── MetadataFetcherOrder
          #     ├── ImageFetchers
          #     └── ImageFetcherOrder
          #
          # It also needs to convert PathInfos from a listOf str to listOf MediaPathInfo->Path->String
          prepassedLibraries = builtins.mapAttrs (name: value:
            value
            // {
              TypeOptions =
                mapAttrsToList (name: value: {
                  TypeOptions = with value; {
                    Type = name;
                    inherit MetadataFetchers;
                    MetadataFetcherOrder = MetadataFetchers;
                    inherit ImageFetchers;
                    ImageFetcherOrder = ImageFetchers;
                  };
                })
                cfg.libraries.${name}.TypeOptions;
              PathInfos = builtins.map (x: {MediaPathInfo.Path = x;}) value.PathInfos;
            })
          cfg.libraries;

          libraryCommands = builtins.concatStringsSep "\n" (mapAttrsToList (name: value: let
              path = "${config.services.jellyfin.dataDir}/root/default/${name}";
            in ''
              mkdir -p '${path}'
              cp -f '${pkgs.writeText "options.xml" (toXml "LibraryOptions" value)}' '${path}/options.xml'
              # Create .mblink files foreach path in library
              ${
                concatStringsSep "\n"
                (map (pathInfo: ''echo -n "${pathInfo.MediaPathInfo.Path}" > "${config.services.jellyfin.dataDir}/root/default/${name}/${builtins.baseNameOf pathInfo.MediaPathInfo.Path}.mblink"'') value.PathInfos)
              }
            '')
            prepassedLibraries);
        in ''
          ${libraryCommands}
          chown -R ${config.services.jellyfin.user}:${config.services.jellyfin.group} "${config.services.jellyfin.dataDir}"
          chmod -R 700 "${config.services.jellyfin.dataDir}"
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
