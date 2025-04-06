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
                  (x: "cp -s \"${pkgs.writeText x.file (toXml x.name x.content)}\" \"/var/lib/jellyfin/config/${x.file}\"")
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

            # ${sq} "INSERT INTO Users (Id, AudioLanguagePreference, AuthenticationProviderId, DisplayCollectionsView, DisplayMissingEpisodes, EnableAutoLogin, EnableLocalPassword, EnableNextEpisodeAutoPlay, EnableUserPreferenceAccess, HidePlayedInLatest, InternalId, LoginAttemptsBeforeLockout, MaxActiveSessions, MaxParentalAgeRating, Password, HashedPasswordFile, PasswordResetProviderId, PlayDefaultAudioTrack, RememberAudioSelections, RememberSubtitleSelections, RemoteClientBitrateLimit, SubtitleLanguagePreference, SubtitleMode, SyncPlayAccess, Username, CastReceiverId) \
            # VALUES(${user.})"
            genUser = index: user: let
              values =
                builtins.mapAttrs
                (name: value:
                  if (isBool value)
                  then
                    if value
                    then "1"
                    else "0"
                  else value)
                (cfg.Users
                  // {
                    Id =
                      if (builtins.hasAttr "Id" cfg.Users)
                      then cfg.Users.Id
                      else "$(${pkgs.libuuid}/bin/uuidgen | ${pkgs.coreutils}/bin/tr '[:lower:]' '[:upper:]')";
                    InternalId =
                      if (builtins.hasAttr "InternalId" cfg.Users)
                      then cfg.Users.InternalId
                      else "$(($maxIndex+${index + 1}))";
                    Password =
                      if (hasAttr "HashedPasswordFile" cfg.Users)
                      then "$(${pkgs.coreutils}/bin/cat \"${cfg.Users.HashedPasswordFile}\")"
                      else "$(${self.packages.${pkgs.system}.genhash}/bin/genhash -k \"${cfg.Users.Password}\" -i 210000 -l 128 -u)";
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
                      options.services.declarative-jellyfin.Users.options)
                  )}) \\
                    VALUES(${builtins.attrValues values})"
                fi
              '';
          in
            /*
            bash
            */
            ''
              mkdir -p ${path}
              # Make sure there is a database
              if [ -z "${path}/${dbname}" ]; then
                cp ${defaultDB} "${path}/${dbname}"
              fi

              maxIndex=$(${sq} 'SELECT InternalId FROM Users ORDER BY InternalId DESC LIMIT 1')
              if [ -n "$maxIndex" ]; then
                maxIndex="1"
              fi

            ''
        );
      };
    };
}
