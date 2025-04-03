{
  lib,
  config,
  ...
}:
with lib; let
  mkStrOption = default: description: mkOption {
    type = types.str;
    inherit default description;
  };
in {
  options.services.declarative-jellyfin.system = {
    ServerName = mkStrOption config.networking.hostName ''
      This name will be used to identify the server and will default to the server's hostname.
    '';

    # Language
    PreferredMetadataLanguage = mkStrOption "en" "Display language of jellyfin.";

    MetadataCountryCode = mkStrOption "US" ''
      Country code for language. Determines stuff like dates, comma placement etc.
    '';

    # Paths
    CachePath = mkStrOption "/var/cache/jellyfin" ''
      Specify a custom location for server cache files such as images.
    '';

    MetadataPath = mkStrOption "/var/lib/jellyfin/metadata" ''
      Specify a custom location for downloaded artwork and metadata.
    '';

    LogFileRetentionDays = mkOption {
      type = types.int;
      default = 3;
    };

    IsStartupWizardComplated = mkOption {
      type = types.bool;
      default = true;
    };

    EnableMetrics = mkEnableOption "metrics";

    EnableNormalizedItemByNameIds = mkOption {
      type = types.bool;
      default = true;
    };

    IsPortAuthorized = mkOption {
      type = types.bool;
      default = true;
    };

    QuickConnectAvailable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether or not to enable quickconnect
      '';
    };

    EnableCaseSensitiveItemIds = mkOption {
      type = types.bool;
      default = true;
    };

    DisableLiveTvChannelUserDataName = mkOption {
      type = types.bool;
      default = true;
    };

    SortReplaceCharacters = mkOption {
      type = with types; listOf str;
      default = [
        "."
        "+"
        "%"
      ];
    };

    SortRemoveCharacters = mkOption {
      type = with types; listOf str;
      default = [
        ","
        "&"
        "-"
        "{"
        "}"
        "'"
      ];
    };

    SortRemoveWords = mkOption {
      type = with types; listOf str;
      default = [
        "the"
        "a"
        "an"
      ];
    };

    # Resume
    MinResumePct = mkOption {
      type = types.int;
      default = 5;
      description = ''
        Titles are assumed unplayed if stopped before this time.
      '';
    };

    MaxResumePct = mkOption {
      type = types.int;
      default = 90;
      description = ''
        Titles are assumed fully played if stopped after this time.
      '';
    };

    MinAudiobookResume = mkOption {
      type = types.int;
      default = 5;
      description = ''
        Titles are assumed unplayed if stopped before this time.
      '';
    };

    MaxAudiobookResume = mkOption {
      type = types.int;
      default = 5;
      description = ''
        Titles are assumed fully played if stopped when the remaining duration is less than this value.
      '';
    };

    MinResumeDurationSeconds = mkOption {
      type = types.int;
      default = 300;
      description = ''
        The shortest video length in seconds that will save playback location and let you resume.
      '';
    };

    InactiveSessionThreshhold = mkOption {
      type = types.int;
      default = 0;
    };

    LibraryMonitorDelay = mkOption {
      type = types.int;
      default = 60;
    };

    LibraryUpdateDuration = mkOption {
      type = types.int;
      default = 30;
    };

    ImageSavingConvention = mkOption {
      type = types.enum ["Legacy"];
      default = "Legacy";
      description = "i got no idea what this is";
    };

    MetadataOptions = mkOption {
      type = with types; listOf attrs;
      default = [
        {
          tag = "MetadataOptions";
          content = {
            ItemType = "Movie";
            DisabledMetadataSavers = [];
            DisabledMetadataFetchers = [];
            LocalMetadataReaderOrder = [];
            MetadataFetcherOrder = [];
            DisabledImageFetchers = [];
            ImageFetcherOrder = [];
          };
        }
        {
          tag = "MetadataOptions";
          content = {
            ItemType = "MusicVideo";
            DisabledMetadataSavers = [];
            DisabledMetadataFetchers = ["The Open Movie Database"];
            LocalMetadataReaderOrder = [];
            MetadataFetcherOrder = [];
            DisabledImageFetchers = ["The Open Movie Database"];
            ImageFetcherOrder = [];
          };
        }
        {
          tag = "MetadataOptions";
          content = {
            ItemType = "Series";
            DisabledMetadataSavers = [];
            DisabledMetadataFetchers = [];
            LocalMetadataReaderOrder = [];
            MetadataFetcherOrder = [];
            DisabledImageFetchers = [];
            ImageFetcherOrder = [];
          };
        }
        {
          tag = "MetadataOptions";
          content = {
            ItemType = "MusicAlbum";
            DisabledMetadataSavers = [];
            DisabledMetadataFetchers = ["TheAudioDB"];
            LocalMetadataReaderOrder = [];
            MetadataFetcherOrder = [];
            DisabledImageFetchers = [];
            ImageFetcherOrder = [];
          };
        }
        {
          tag = "MetadataOptions";
          content = {
            ItemType = "MusicArtist";
            DisabledMetadataSavers = [];
            DisabledMetadataFetchers = ["TheAudioDB"];
            LocalMetadataReaderOrder = [];
            MetadataFetcherOrder = [];
            DisabledImageFetchers = [];
            ImageFetcherOrder = [];
          };
        }
        {
          tag = "MetadataOptions";
          content = {
            ItemType = "BoxSet";
            DisabledMetadataSavers = [];
            DisabledMetadataFetchers = [];
            LocalMetadataReaderOrder = [];
            MetadataFetcherOrder = [];
            DisabledImageFetchers = [];
            ImageFetcherOrder = [];
          };
        }
        {
          tag = "MetadataOptions";
          content = {
            ItemType = "Season";
            DisabledMetadataSavers = [];
            DisabledMetadataFetchers = [];
            LocalMetadataReaderOrder = [];
            MetadataFetcherOrder = [];
            DisabledImageFetchers = [];
            ImageFetcherOrder = [];
          };
        }
        {
          tag = "MetadataOptions";
          content = {
            ItemType = "Episode";
            DisabledMetadataSavers = [];
            DisabledMetadataFetchers = [];
            LocalMetadataReaderOrder = [];
            MetadataFetcherOrder = [];
            DisabledImageFetchers = [];
            ImageFetcherOrder = [];
          };
        }
      ];
    };

    SkipDeserializationForBasicTypes = mkOption {
      type = types.bool;
      default = true;
    };

    UICulture = mkOption {
      type = types.str;
      default = "en-US";
    };

    SaveMetadataHidden = mkEnableOption "";

    ContentTypes = mkOption {
      type = with types; listOf str;
      default = [];
    };

    RemoteClientBitrateLimit = mkOption {
      type = types.int;
      default = 0;
    };

    EnableFolderView = mkEnableOption "";

    EnableGroupingIntoCollections = mkEnableOption "";

    DisplaySpecialsWithinSeasons = mkOption {
      type = types.bool;
      default = true;
    };

    CodecsUsed = mkOption {
      type = with types; listOf str;
      default = [];
    };

    PluginRepositories = mkOption {
      type = with types; listOf attrs;
      default = [
        {
          tag = "RepositoryInfo";
          content = {
            Name = "Jellyfin Stable";
            Url = "https://repo.jellyfin.org/files/plugin/manifest.json";
          };
        }
      ];
      description = "Configure which plugin repositories you use.";
    };

    EnableExternalContentInSuggestions = mkOption {
      type = types.bool;
      default = true;
    };

    ImageExtractionTimeoutMs = mkOption {
      type = types.int;
      default = 0;
      description = "Leave at 0 for no timeout";
    };

    PathSubstitutions = mkOption {
      type = with types; listOf str;
      default = [];
    };

    EnableSlowResponseWarning = mkOption {
      type = types.bool;
      default = true;
    };

    SlowResponseThresholdMs = mkOption {
      type = types.int;
      default = 500;
      description = "How slow (in ms) would a response have to be before a warning is shown";
    };

    CorsHosts = mkOption {
      type = with types; listOf str;
      default = [
        "*"
      ];
    };

    ActivityLogRetentionDays = mkOption {
      type = types.int;
      default = 30;
    };

    LibraryScanFanoutConcurrency = mkOption {
      type = types.int;
      default = 0;
      description = ''
        Maximum number of parallel tasks during library scans.
        Setting this to 0 will choose a limit based on your systems core count.
        WARNING: Setting this number too high may cause issues with network file systems; if you encounter problems lower this number.
      '';
    };

    LibraryMetadataRefreshConcurrency = mkOption {
      type = types.int;
      default = 0;
      description = ''
        Maximum number of parallel tasks during library scans.
        Setting this to 0 will choose a limit based on your systems core count.
        WARNING: Setting this number too high may cause issues with network file systems; if you encounter problems lower this number.
      '';
    };

    RemoveOldPlugins = mkOption {
      type = types.bool;
      default = true;
    };

    AllowClientLogUpload = mkOption {
      type = types.bool;
      default = true;
    };

    DummyChapterDuration = mkOption {
      type = types.int;
      default = 0;
    };

    ChapterImageResolution = mkOption {
      type = types.enum [
        "MatchSource"
        "2160p"
        "1440p"
        "1080p"
        "720p"
        "480p"
        "360p"
        "240p"
        "144p"
      ];
      default = "MatchSource";
      description = ''
        The resolution of the extracted chapter images.
        Changing this will have no effect on existing dummy chapters.
      '';
    };

    ParallelImageEncodingLimit = mkOption {
      type = types.int;
      default = 0;
      description = ''
        Maximum number of image encodings that are allowed to run in parallel.
        Setting this to 0 will choose a limit based on your systems core count.
      '';
    };

    CastReceiverApplications = mkOption {
      type = with types; listOf attrs;
      default = [
        {
          tag = "CastRecieverApplication";
          content = {
            Id = "F007D354";
            Name = "Stable";
          };
        }
        {
          tag = "CastRecieverApplication";
          content = {
            Id = "6F511C87";
            Name = "Unstable";
          };
        }
      ];
    };

    TrickplayOptions = {
      EnableHwAcceleration = mkEnableOption "Enable hardware acceleration";

      EnableHwEncoding = mkEnableOption "Currently only available on QSV, VA-API, VideoToolbox and RKMPP, this option has no effect on other hardware acceleration methods.";

      EnableKeyFrameOnlyExtraction = mkEnableOption ''
        Extract key frames only for significantly faster processing with less accurate timing.
        If the configured hardware decoder does not support this mode, will use the software decoder instead.
      '';

      ScanBehavior = mkOption {
        type = types.enum ["NonBlocking" "Blocking"];
        default = "NonBlocking";
        description = ''
          The default behavior is non blocking, which will add media to the library before trickplay generation is done. Blocking will ensure trickplay files are generated before media is added to the library, but will make scans significantly longer.
        '';
      };

      ProcessPriority = mkOption {
        type = types.enum [
          "High"
          "AboveNormal"
          "Normal"
          "BelowNormal"
          "Idle"
        ];
        default = "BelowNormal";
        description = ''
          Setting this lower or higher will determine how the CPU prioritizes the ffmpeg trickplay generation process in relation to other processes.
          If you notice slowdown while generating trickplay images but don't want to fully stop their generation, try lowering this as well as the thread count.
        '';
      };

      Interval = mkOption {
        type = types.int;
        default = 10000;
        description = ''
          Interval of time (ms) between each new trickplay image.
        '';
      };

      WidthResolutions = mkOption {
        type = with types; listOf attrs;
        default = [
          {
            tag = "int";
            content = 320;
          }
        ];
        description = ''
          List of the widths (px) that trickplay images will be generated at.
          All images should generate proportionally to the source, so a width of 320 on a 16:9 video ends up around 320x180.
        '';
      };

      TileWidth = mkOption {
        type = types.int;
        default = 10;
        description = ''
          Maximum number of images per tile in the X direction.
        '';
      };

      TileHeight = mkOption {
        type = types.int;
        default = 10;
        description = ''
          Maximum number of images per tile in the X direction.
        '';
      };

      Qscale = mkOption {
        type = types.ints.between 2 31;
        default = 4;
        description = ''
          The quality scale of images output by ffmpeg, with 2 being the highest quality and 31 being the lowest.
        '';
      };

      JpegQuality = mkOption {
        type = types.ints.between 0 100;
        default = 90;
        description = ''
          The JPEG compression quality for trickplay images.
        '';
      };

      ProcessThreads = mkOption {
        type = types.int;
        default = 1;
        description = ''
          The number of threads to pass to the '-threads' argument of ffmpeg.
        '';
      };
    };
  };
}
