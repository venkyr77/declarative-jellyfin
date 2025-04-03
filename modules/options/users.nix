{lib, ...}:
with lib; {
  options.services.declarative-jellyfin.
  # Based on: https://github.com/jellyfin/jellyfin/blob/master/MediaBrowser.Model/Configuration/UserConfiguration.cs
  Users = mkOption {
    description = "User configuration";
    type = lib.types.listOf (lib.types.submodule ({config, ...}: {
      options = {
        Id = mkOption {
          type = types.str; # TODO: Limit the id to the pattern: "18B51E25-33FD-46B6-BBF8-DB4DD77D0679"
          description = "The ID of the user";
          default = "autogenerate";
          example = "18B51E25-33FD-46B6-BBF8-DB4DD77D0679";
        };
        AudioLanguagePreference = mkOption {
          type = with types; either null str;
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
          type = with types; either int str; # TODO: Limit string to "autogenerate"
          # NOTE: index is 1-indexed! NOT 0-indexed.
          description = "The index of the user in the database. Be careful setting this option. 1 indexed.";
          default = "autogenerate";
          example = 69;
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
          type = with types; either null int;
          # idk no docs man
          default = null;
        };
        Password = mkOption {
          type = types.str;
          # TODO: implement
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
          type = with types; either null str;
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
      };

      # Omitted database columns:
      # InvalidLoginAttemptCount
      # LastActivityDate
      # LastLoginDate
      # MustUpdatePassword
      # RowVersion
    }));
  };
}
