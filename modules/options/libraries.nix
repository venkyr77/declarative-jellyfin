{lib, ...}:
with lib; let
  LibraryOpts = {
    name,
    config,
    ...
  }: {
    options = with lib; {
      Enabled = mkOption {
        type = types.bool;
        default = true;
        description = "Whether or not this library is enabled";
      };
      EnablePhotos = mkOption {
        type = types.bool;
        default = true;
        description = "Whether or not media in this library should display photos";
      };
      EnableRealtimeMonitor = mkOption {
        type = types.bool;
        default = true;
        description = "Toggles if the admin dashboard should show media being streamed from this library";
      };
      EnableLUFSScan = mkOption {
        type = types.bool;
        default = true;
        # TODO: Figure out what this option does
        # description = "";
      };
      EnableChapterImageExtraction = mkOption {
        type = types.bool;
        default = false;
        description = "Whether or not to extract frames from the media to show as previews for chapters";
      };
      ExtractChapterImagesDuringLibraryScan = mkOption {
        type = types.bool;
        default = false;
        description = "Whether or not to extract frames for previews for chapters during library scans";
      };
      EnableTrickplayImageExtraction = mkOption {
        type = types.bool;
        default = false;
        description = "Enables trickplay image generation for previews when skipping in media";
      };
      ExtractTrickplayImagesDuringLibraryScan = mkOption {
        type = types.bool;
        default = false;
        description = "Whether or not trickplay images should be extracted during the library scan";
      };
      PathInfos = mkOption {
        type = with types; listOf str;
        description = "List of paths for media in this library";
      };
      SaveLocalMetadata = mkOption {
        type = types.bool;
        default = false;
        # TODO: Figure out what this option does
        # description = "";
      };
      EnableAutomaticSeriesGrouping = mkOption {
        type = types.bool;
        default = false;
        description = "Series that are spread across multiple folders within this library will be automatically merged into a single series.";
      };
      EnableEmbeddedTitles = mkOption {
        type = types.bool;
        default = false;
        description = "Whether or not to use the title embedded in the file if no internet metadata is available (if any is embedded)";
      };
      EnableEmbeddedExtraTitles = mkOption {
        type = types.bool;
        default = false;
        description = "Use the episode information from the embedded metadata if available.";
      };
      EnableEmbeddedEpisodeInfos = mkOption {
        type = types.bool;
        default = false;
        # TODO: Figure out what this does
        # description = "";
      };
      AutomaticRefreshIntervalDays = mkOption {
        type = types.int;
        default = 30;
        description = "How often to automatically refresh metadata from the internet. (in days)";
      };
      SeasonZeroDisplayName = mkOption {
        type = types.str;
        default = "Specials";
        description = "What title should the 'specials' season (season 0) display?";
      };
      PreferredMetadataLanguage = mkOption {
        type = types.str;
        default = "en";
        description = "What language should metadata be fetched for? Affects titles, descriptions, etc.";
      };
      MetadataCountryCode = mkOption {
        type = types.str;
        default = "";
        # TODO: Figure out what this does
        # description = "idk";
      };
      MetadataSavers = mkOption {
        type = with types; listOf str;
        default = [];
        description = "Pick the file formats to use when saving your metadata.";
        example = ["Nfo"];
      };
      DisabledLocalMetadataReaders = mkOption {
        type = with types; listOf str;
        default = [];
        # TODO: find out what this does
        # description = "What title should the 'specials' season (season 0) display?";
      };
      LocalMetadataReaderOrder = mkOption {
        type = with types; listOf str;
        default = ["Nfo"];
        description = "What order should local metadata readers be prioritised";
      };
      DisabledSubtitleFetchers = mkOption {
        type = with types; listOf str;
        default = [];
        description = "What order should local metadata readers be prioritised";
        example = ["Open Subtitles"];
      };
      SubtitleFetcherOrder = mkOption {
        type = with types; listOf str;
        default = ["Open Subtitles"];
        description = "Enable and rank your preferred subtitle downloaders in order of priority.";
      };
      DisabledMediaSegmentProviders = mkOption {
        type = with types; listOf str;
        default = [];
        # TODO: Find out what this does
        # description = "Enable and rank your preferred subtitle downloaders in order of priority.";
      };
      MediaSegmentProvideOrder = mkOption {
        type = with types; listOf str;
        default = [];
        # TODO: Find out what this does
        # description = "Enable and rank your preferred subtitle downloaders in order of priority.";
      };
      SkipSubtitlesIfEmbeddedSubtitlesPresent = mkOption {
        type = types.bool;
        default = false;
        description = "Keeping text versions of subtitles will result in more efficient delivery and decrease the likelihood of video transcoding.";
      };
      SkipSubtitlesIfAudioTrackMatches = mkOption {
        type = types.bool;
        default = false;
        description = "Uncheck this to ensure all videos have subtitles, regardless of audio language.";
      };
      SubtitleDownloadLanguages = mkOption {
        type = with types; listOf str;
        default = ["eng"];
      };
      RequirePerfectSubtitleMatch = mkOption {
        type = types.bool;
        default = true;
      };
      SaveSubtitlesWithMedia = mkOption {
        type = types.bool;
        default = true;
        description = "Storing subtitles next to video files will allow them to be more easily managed.";
      };

      DisabledLyricFetchers = mkOption {
        type = with types; listOf str;
        default = [];
      };
      LyricFetcherOrder = mkOption {
        type = with types; listOf str;
        default = [];
      };

      CustomTagDelimiters = mkOption {
        type = with types; listOf str;
        default = [
          "/"
          "|"
          ";"
          "\\"
        ];
      };
      DelimiterWhitelist = mkOption {
        type = with types; listOf str;
        default = [];
      };
      AutomaticallyAddToCollection = mkOption {
        type = types.bool;
        default = false;
        description = "Toggles whether or not similar series/shows (ie. sequals or spinoffs) will be grouped in collections.";
      };
      AllowEmbeddedSubtitles = mkOption {
        type = with types; enum ["AllowAll" "AllowText" "AllowImages" "AllowNone"];
        default = "AllowAll";
        description = "Disable subtitles that are packaged within media containers. Requires a full library refresh.";
      };
      # OBS:  This is an abstraction of the file contents. It will need to be transformed
      #       before use.
      TypeOptions = let
        typeOption = {
          MetadataFetchers = mkOption {
            type = with types; listOf str;
            default = ["TheTVDB" "The Open Movie Database" "TheMovieDb"];
            description = "Enable and rank your preferred metadata downloaders in order of priority. Lower priority downloaders will only be used to fill in missing information.";
          };
          ImageFetchers = mkOption {
            type = with types; listOf str;
            default = ["TheTVDB" "TheMovieDb"];
            description = "Enable and rank your preferred image fetchers in order of priority.";
          };
        };
      in {
        Series = typeOption;
        Season = typeOption;
        Episode = typeOption;
      };
    };
  };
in {
  options.services.declarative-jellyfin.libraries = mkOption {
    description = "Library configuration";
    default = {};
    type = with types; attrsOf (submodule LibraryOpts);
    example = {
      "Anime" = {
        Enabled = true;
        EnableTrickplayImageExtraction = true;
        TypeOptions.Series.MetadataFetchers = ["TheTVDB" "TheMovieDb" "AniList"];
      };
    };
  };
}
