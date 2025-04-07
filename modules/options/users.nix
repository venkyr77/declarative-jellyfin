{lib, ...}:
with lib; {
  options.services.declarative-jellyfin.
  # Based on: https://github.com/jellyfin/jellyfin/blob/master/MediaBrowser.Model/Configuration/UserConfiguration.cs
  Users = mkOption {
    description = "User configuration";
    default = [];
    type = lib.types.listOf (lib.types.submodule ({config, ...}: {
      options = {
        Id = mkOption {
          type = types.nullOr types.str; # TODO: Limit the id to the pattern: "18B51E25-33FD-46B6-BBF8-DB4DD77D0679"
          description = "The ID of the user";
          example = "18B51E25-33FD-46B6-BBF8-DB4DD77D0679";
          default = null;
        };
        AudioLanguagePreference = mkOption {
          type = with types; nullOr str;
          description = "The audio language preference. Defaults to 'Any Language'";
          default = null;
          example = "eng";
        };
        AuthenticationProviderId = mkOption {
          type = types.str;
          # idk no docs man
          default = "Jellyfin.Server.Implementations.Users.DefaultAuthenticationProvider";
        };
        DisplayCollectionsView = mkOption {
          type = types.bool;
          description = "Whether to show the Collections View";
          default = false;
          example = true;
        };
        DisplayMissingEpisodes = mkOption {
          type = types.bool;
          description = "Whether to show missing episodes";
          default = false;
          example = true;
        };
        EnableAutoLogin = mkOption {
          type = types.bool;
          default = false;
          example = true;
        };
        EnableLocalPassword = mkOption {
          type = types.bool;
          default = false;
          example = true;
        };
        EnableNextEpisodeAutoPlay = mkOption {
          type = types.bool;
          description = "Automatically play the next episode";
          default = true;
          example = false;
        };
        EnableUserPreferenceAccess = mkOption {
          type = types.bool;
          # idk no docs man
          default = true;
          example = false;
        };
        HidePlayedInLatest = mkOption {
          type = types.bool;
          description = "Whether to hide already played titles in the 'Latest' section";
          default = true;
          example = false;
        };
        InternalId = mkOption {
          type = with types; nullOr int;
          # NOTE: index is 1-indexed! NOT 0-indexed.
          description = "The index of the user in the database. Be careful setting this option. 1 indexed.";
          example = 69;
          default = null;
        };
        LoginAttemptsBeforeLockout = mkOption {
          type = types.int;
          description = "The number of login attempts the user can make before they are locked out.";
          default = 3;
          example = 10;
        };
        MaxActiveSessions = mkOption {
          type = types.int;
          description = "The maximum number of active sessions the user can have at once. 0 for unlimited";
          default = 0;
          example = 5;
        };
        MaxParentalAgeRating = mkOption {
          type = with types; nullOr int;
          # idk no docs man
          default = null;
        };
        Password = mkOption {
          type = with types; nullOr str;
          default = null;
        };
        HashedPasswordFile = mkOption {
          type = types.nullOr types.path;
          description = ''
            A path to a pbkdf2-sha512 hash
            in this format [PHC string](https://github.com/P-H-C/phc-string-format/blob/master/phc-sf-spec.md).
            You can use the packaged 'genhash' tool in this flake.nix to generate a hash
            ```
            # default values:
            nix run gitlab:SpoodyTheOne/declarative-jellyfin#genhash -- \\
              -k <password> \\
              -i 210000 \\
              -l 128 \\
              -u
            # Usage:
            nix run gitlab:SpoodyTheOne/declarative-jellyfin#genhash -h

            ```
          '';
          default = null;
          example = ''
            # the format is: $<id>[$<param>=<value>(,<param>=<value>)*][$<salt>[$<hash>]]
            $PBKDF2-SHA512$iterations=210000$D12C02D1DD15949D867BCA9971BE9987$67E75CDCD14E7F6FDDF96BAACBE9E84E5197FB9FE454FB039F5CD773D7DF558B57DC81DB42B6F7CF0E6B8207A771E5C0EE0DBFD91CE5BAF804FE53F70E61CD2E
          '';
        };
        PasswordResetProviderId = mkOption {
          type = types.str;
          # no docs man
          default = "Jellyfin.Server.Implementations.Users.DefaultPasswordResetProvider";
        };
        PlayDefaultAudioTrack = mkOption {
          type = types.bool;
          default = true;
          example = false;
        };
        RememberAudioSelections = mkOption {
          type = types.bool;
          default = true;
        };
        RememberSubtitleSelections = mkOption {
          type = types.bool;
          default = true;
        };
        RemoteClientBitrateLimit = mkOption {
          type = types.int;
          description = "0 for unlimited";
          default = 0;
        };
        SubtitleLanguagePreference = mkOption {
          type = with types; nullOr str;
          description = "The subtitle language preference. Defaults to 'Any Language'";
          default = null;
          example = "eng";
        };
        # https://github.com/jellyfin/jellyfin/blob/master/src/Jellyfin.Database/Jellyfin.Database.Implementations/Enums/SubtitlePlaybackMode.cs
        SubtitleMode = mkOption {
          type = types.enum ["Default" "Always" "OnlyForced" "None" "Smart"];
          description = ''
            Default: The default subtitle playback mode.
            Always: Always show subtitles.
            OnlyForced: Only show forced subtitles.
            None: Don't show subtitles.
            Smart: Only show subtitles when the current audio stream is in a different language.
          '';
          default = "Default";
        };
        SyncPlayAccess = mkOption {
          type = types.bool;
          description = "Whether or not this user has access to SyncPlay";
          default = false;
          example = true;
        };
        Username = mkOption {
          type = types.str;
          description = "The username for the user";
        };
        # Something to do with chromecast, don't know tbh
        CastReceiverId = mkOption {
          type = types.str;
          default = "F007D354";
        };
        InvalidLoginAttemptCount = mkOption {
          type = types.int;
          default = 0;
        };
        MustUpdatePassword = mkOption {
          type = types.int;
          default = 0;
        };
        RowVersion = mkOption {
          type = types.int;
          default = 0;
        };

        LastActivityDate = mkOption {
          type = with types; nullOr str;
          default = null;
        };
        LastLoginDate = mkOption {
          type = with types; nullOr str;
          default = null;
        };
      };
    }));
  };
}
