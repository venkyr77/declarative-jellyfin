This documentation is auto-generated
# system
## system.UICulture

**Type**: string

**Default**: `"en-US"`

## system.activityLogRetentionDays

**Type**: signed integer

**Default**: `30`

## system.allowClientLogUpload

**Type**: boolean

**Default**: `true`

## system.cachePath
Specify a custom location for server cache files such as images.


**Type**: string

**Default**: `"/var/cache/jellyfin"`

## system.castReceiverApplications

**Type**: list of (attribute set)

**Default**: 
```nix
[
 {
  content = {
   Id = "F007D354";
   Name = "Stable";
  };
  tag = "CastRecieverApplication";
 }
 {
  content = {
   Id = "6F511C87";
   Name = "Unstable";
  };
  tag = "CastRecieverApplication";
 }
]
```

## system.chapterImageResolution
The resolution of the extracted chapter images.
Changing this will have no effect on existing dummy chapters.


**Type**: one of "MatchSource", "2160p", "1440p", "1080p", "720p", "480p", "360p", "240p", "144p"

**Default**: `"MatchSource"`

## system.codecsUsed

**Type**: list of string

**Default**: `[]`

## system.contentTypes

**Type**: list of string

**Default**: `[]`

## system.corsHosts

**Type**: list of string

**Default**: 
```nix
[
 "*"
]
```

## system.disableLiveTvChannelUserDataName

**Type**: boolean

**Default**: `true`

## system.displaySpecialsWithinSeasons

**Type**: boolean

**Default**: `true`

## system.dummyChapterDuration

**Type**: signed integer

**Default**: `0`

## system.enableCaseSensitiveItemIds

**Type**: boolean

**Default**: `true`

## system.enableExternalContentInSuggestions

**Type**: boolean

**Default**: `true`

## system.enableFolderView
Whether to enable .

**Type**: boolean

**Default**: `false`

## system.enableGroupingIntoCollections
Whether to enable .

**Type**: boolean

**Default**: `false`

## system.enableMetrics
Whether to enable metrics.

**Type**: boolean

**Default**: `false`

## system.enableNormalizedItemByNameIds

**Type**: boolean

**Default**: `true`

## system.enableSlowResponseWarning

**Type**: boolean

**Default**: `true`

## system.imageExtractionTimeoutMs
Leave at 0 for no timeout

**Type**: signed integer

**Default**: `0`

## system.imageSavingConvention
i got no idea what this is

**Type**: value "Legacy" (singular enum)

**Default**: `"Legacy"`

## system.inactiveSessionThreshhold

**Type**: signed integer

**Default**: `0`

## system.isPortAuthorized

**Type**: boolean

**Default**: `true`

## system.isStartupWizardCompleted
Controls whether or not Declarative Jellyfin will mark the startup wizard as completed.
Set to `false` to show the startup wizard when visiting jellyfin (not recommended as this
will happen every time jellyfin is restarted)


**Type**: boolean

**Default**: `true`

## system.libraryMetadataRefreshConcurrency
Maximum number of parallel tasks during library scans.
Setting this to 0 will choose a limit based on your systems core count.
WARNING: Setting this number too high may cause issues with network file systems; if you encounter problems lower this number.


**Type**: signed integer

**Default**: `0`

## system.libraryMonitorDelay

**Type**: signed integer

**Default**: `60`

## system.libraryScanFanoutConcurrency
Maximum number of parallel tasks during library scans.
Setting this to 0 will choose a limit based on your systems core count.
WARNING: Setting this number too high may cause issues with network file systems; if you encounter problems lower this number.


**Type**: signed integer

**Default**: `0`

## system.libraryUpdateDuration

**Type**: signed integer

**Default**: `30`

## system.logFileRetentionDays
The amount of days that jellyfin should keep log files before deleting.


**Type**: signed integer

**Default**: `3`

## system.maxAudiobookResume
Titles are assumed fully played if stopped when the remaining duration is less than this value.


**Type**: signed integer

**Default**: `5`

## system.maxResumePct
Titles are assumed fully played if stopped after this time.


**Type**: signed integer

**Default**: `90`

## system.metadataCountryCode
Country code for language. Determines stuff like dates, comma placement etc.


**Type**: string

**Default**: `"US"`

## system.metadataOptions

**Type**: list of (attribute set)

**Default**: 
```nix
[
 {
  content = {
   disabledImageFetchers = [];
   disabledMetadataFetchers = [];
   disabledMetadataSavers = [];
   imageFetcherOrder = [];
   itemType = "Movie";
   localMetadataReaderOrder = [];
   metadataFetcherOrder = [];
  };
  tag = "MetadataOptions";
 }
 {
  content = {
   disabledImageFetchers = [
    "The Open Movie Database"
   ];
   disabledMetadataFetchers = [
    "The Open Movie Database"
   ];
   disabledMetadataSavers = [];
   imageFetcherOrder = [];
   itemType = "MusicVideo";
   localMetadataReaderOrder = [];
   metadataFetcherOrder = [];
  };
  tag = "MetadataOptions";
 }
 {
  content = {
   disabledImageFetchers = [];
   disabledMetadataFetchers = [];
   disabledMetadataSavers = [];
   imageFetcherOrder = [];
   itemType = "Series";
   localMetadataReaderOrder = [];
   metadataFetcherOrder = [];
  };
  tag = "MetadataOptions";
 }
 {
  content = {
   disabledImageFetchers = [];
   disabledMetadataFetchers = [
    "TheAudioDB"
   ];
   disabledMetadataSavers = [];
   imageFetcherOrder = [];
   itemType = "MusicAlbum";
   localMetadataReaderOrder = [];
   metadataFetcherOrder = [];
  };
  tag = "MetadataOptions";
 }
 {
  content = {
   ImageFetcherOrder = [];
   disabledImageFetchers = [];
   disabledMetadataFetchers = [
    "TheAudioDB"
   ];
   disabledMetadataSavers = [];
   itemType = "MusicArtist";
   localMetadataReaderOrder = [];
   metadataFetcherOrder = [];
  };
  tag = "MetadataOptions";
 }
 {
  content = {
   disabledImageFetchers = [];
   disabledMetadataFetchers = [];
   disabledMetadataSavers = [];
   imageFetcherOrder = [];
   itemType = "BoxSet";
   localMetadataReaderOrder = [];
   metadataFetcherOrder = [];
  };
  tag = "MetadataOptions";
 }
 {
  content = {
   disabledImageFetchers = [];
   disabledMetadataFetchers = [];
   disabledMetadataSavers = [];
   imageFetcherOrder = [];
   itemType = "Season";
   localMetadataReaderOrder = [];
   metadataFetcherOrder = [];
  };
  tag = "MetadataOptions";
 }
 {
  content = {
   disabledImageFetchers = [];
   disabledMetadataFetchers = [];
   disabledMetadataSavers = [];
   imageFetcherOrder = [];
   itemType = "Episode";
   localMetadataReaderOrder = [];
   metadataFetcherOrder = [];
  };
  tag = "MetadataOptions";
 }
]
```

## system.metadataPath
Specify a custom location for downloaded artwork and metadata.


**Type**: string

**Default**: `"/var/lib/jellyfin/metadata"`

## system.minAudiobookResume
Titles are assumed unplayed if stopped before this time.


**Type**: signed integer

**Default**: `5`

## system.minResumeDurationSeconds
The shortest video length in seconds that will save playback location and let you resume.


**Type**: signed integer

**Default**: `300`

## system.minResumePct
Titles are assumed unplayed if stopped before this time.


**Type**: signed integer

**Default**: `5`

## system.parallelImageEncodingLimit
Maximum number of image encodings that are allowed to run in parallel.
Setting this to 0 will choose a limit based on your systems core count.


**Type**: signed integer

**Default**: `0`

## system.pathSubstitutions

**Type**: list of string

**Default**: `[]`

## system.pluginRepositories
Configure which plugin repositories you use.

**Type**: list of (attribute set)

**Default**: 
```nix
[
 {
  content = {
   Name = "Jellyfin Stable";
   Url = "https://repo.jellyfin.org/files/plugin/manifest.json";
  };
  tag = "RepositoryInfo";
 }
]
```

## system.preferredMetadataLanguage
Display language of jellyfin.

**Type**: string

**Default**: `"en"`

## system.quickConnectAvailable
Whether or not to enable quickconnect


**Type**: boolean

**Default**: `true`

## system.remoteClientBitrateLimit

**Type**: signed integer

**Default**: `0`

## system.removeOldPlugins

**Type**: boolean

**Default**: `true`

## system.saveMetadataHidden
Whether to enable .

**Type**: boolean

**Default**: `false`

## system.serverName
This name will be used to identify the server and will default to the server's hostname.


**Type**: string

**Default**: `"config.networking.hostName"`

## system.skipDeserializationForBasicTypes

**Type**: boolean

**Default**: `true`

## system.slowResponseThresholdMs
How slow (in ms) would a response have to be before a warning is shown

**Type**: signed integer

**Default**: `500`

## system.sortRemoveCharacters

**Type**: list of string

**Default**: 
```nix
[
 ","
 "&"
 "-"
 "{"
 "}"
 "'"
]
```

## system.sortRemoveWords

**Type**: list of string

**Default**: 
```nix
[
 "the"
 "a"
 "an"
]
```

## system.sortReplaceCharacters

**Type**: list of string

**Default**: 
```nix
[
 "."
 "+"
 "%"
]
```

## system.trickplayOptions
### system.trickplayOptions.enableHwAcceleration
Whether to enable Enable hardware acceleration.

**Type**: boolean

**Default**: `false`

### system.trickplayOptions.enableHwEncoding
Whether to enable Currently only available on QSV, VA-API, VideoToolbox and RKMPP, this option has no effect on other hardware acceleration methods..

**Type**: boolean

**Default**: `false`

### system.trickplayOptions.enableKeyFrameOnlyExtraction
Whether to enable Extract key frames only for significantly faster processing with less accurate timing.
If the configured hardware decoder does not support this mode, will use the software decoder instead.
.

**Type**: boolean

**Default**: `false`

### system.trickplayOptions.interval
Interval of time (ms) between each new trickplay image.


**Type**: signed integer

**Default**: `10000`

### system.trickplayOptions.jpegQuality
The JPEG compression quality for trickplay images.


**Type**: integer between 0 and 100 (both inclusive)

**Default**: `90`

### system.trickplayOptions.processPriority
Setting this lower or higher will determine how the CPU prioritizes the ffmpeg trickplay generation process in relation to other processes.
If you notice slowdown while generating trickplay images but don't want to fully stop their generation, try lowering this as well as the thread count.


**Type**: one of "High", "AboveNormal", "Normal", "BelowNormal", "Idle"

**Default**: `"BelowNormal"`

### system.trickplayOptions.processThreads
The number of threads to pass to the '-threads' argument of ffmpeg.


**Type**: signed integer

**Default**: `1`

### system.trickplayOptions.qscale
The quality scale of images output by ffmpeg, with 2 being the highest quality and 31 being the lowest.


**Type**: integer between 2 and 31 (both inclusive)

**Default**: `4`

### system.trickplayOptions.scanBehavior
The default behavior is non blocking, which will add media to the library before trickplay generation is done. Blocking will ensure trickplay files are generated before media is added to the library, but will make scans significantly longer.


**Type**: one of "NonBlocking", "Blocking"

**Default**: `"NonBlocking"`

### system.trickplayOptions.tileHeight
Maximum number of images per tile in the X direction.


**Type**: signed integer

**Default**: `10`

### system.trickplayOptions.tileWidth
Maximum number of images per tile in the X direction.


**Type**: signed integer

**Default**: `10`

### system.trickplayOptions.widthResolutions
List of the widths (px) that trickplay images will be generated at.
All images should generate proportionally to the source, so a width of 320 on a 16:9 video ends up around 320x180.


**Type**: list of (attribute set)

**Default**: 
```nix
[
 {
  content = 320;
  tag = "int";
 }
]
```
# libraries
## libraries.*
### libraries.*.allowEmbeddedSubtitles
Disable subtitles that are packaged within media containers. Requires a full library refresh.

**Type**: one of "AllowAll", "AllowText", "AllowImages", "AllowNone"

**Default**: `"AllowAll"`

### libraries.*.automaticRefreshIntervalDays
How often to automatically refresh metadata from the internet. (in days)

**Type**: signed integer

**Default**: `30`

### libraries.*.automaticallyAddToCollection
Toggles whether or not similar series/shows (ie. sequals or spinoffs) will be grouped in collections.

**Type**: boolean

**Default**: `false`

### libraries.*.contentType
The type of content this library contains. Used for setting the default image/metadata fetchers.


**Type**: one of "movies", "music", "tvshows", "books", "homevideos", "musicvideos", "boxsets"


### libraries.*.customTagDelimiters

**Type**: list of string

**Default**: 
```nix
[
 "/"
 "|"
 ";"
 "\"
]
```

### libraries.*.delimiterWhitelist

**Type**: list of string

**Default**: `[]`

### libraries.*.disabledLocalMetadataReaders

**Type**: list of string

**Default**: `[]`

### libraries.*.disabledLyricFetchers

**Type**: list of string

**Default**: `[]`

### libraries.*.disabledMediaSegmentProviders

**Type**: list of string

**Default**: `[]`

### libraries.*.disabledSubtitleFetchers
What order should local metadata readers be prioritised

**Type**: list of string

**Default**: `[]`

### libraries.*.enableAutomaticSeriesGrouping
Series that are spread across multiple folders within this library will be automatically merged into a single series.

**Type**: boolean

**Default**: `false`

### libraries.*.enableChapterImageExtraction
Whether or not to extract frames from the media to show as previews for chapters

**Type**: boolean

**Default**: `false`

### libraries.*.enableEmbeddedEpisodeInfos

**Type**: boolean

**Default**: `false`

### libraries.*.enableEmbeddedExtraTitles
Use the episode information from the embedded metadata if available.

**Type**: boolean

**Default**: `false`

### libraries.*.enableEmbeddedTitles
Whether or not to use the title embedded in the file if no internet metadata is available (if any is embedded)

**Type**: boolean

**Default**: `false`

### libraries.*.enableLUFSScan

**Type**: boolean

**Default**: `true`

### libraries.*.enablePhotos
Whether or not media in this library should display photos

**Type**: boolean

**Default**: `true`

### libraries.*.enableRealtimeMonitor
Changes to files will be processed immediately on supported file systems

**Type**: boolean

**Default**: `true`

### libraries.*.enableTrickplayImageExtraction
Enables trickplay image generation for previews when skipping in media

**Type**: boolean

**Default**: `false`

### libraries.*.enabled
Whether or not this library is enabled

**Type**: boolean

**Default**: `true`

### libraries.*.extractChapterImagesDuringLibraryScan
Whether or not to extract frames for previews for chapters during library scans

**Type**: boolean

**Default**: `false`

### libraries.*.extractTrickplayImagesDuringLibraryScan
Whether or not trickplay images should be extracted during the library scan

**Type**: boolean

**Default**: `false`

### libraries.*.localMetadataReaderOrder
What order should local metadata readers be prioritised

**Type**: list of string

**Default**: 
```nix
[
 "Nfo"
]
```

### libraries.*.lyricFetcherOrder

**Type**: list of string

**Default**: `[]`

### libraries.*.mediaSegmentProvideOrder

**Type**: list of string

**Default**: `[]`

### libraries.*.metadataCountryCode

**Type**: string

**Default**: `""`

### libraries.*.metadataSavers
Pick the file formats to use when saving your metadata.

**Type**: list of string

**Default**: `[]`

### libraries.*.pathInfos
List of paths for media in this library

**Type**: list of string


### libraries.*.preferredMetadataLanguage
What language should metadata be fetched for? Affects titles, descriptions, etc.

**Type**: string

**Default**: `"en"`

### libraries.*.requirePerfectSubtitleMatch

**Type**: boolean

**Default**: `true`

### libraries.*.saveLocalMetadata

**Type**: boolean

**Default**: `false`

### libraries.*.saveLyricsWithMedia
Saving lyrics into media folders will put them next to your media for easy migration and access

**Type**: boolean

**Default**: `false`

### libraries.*.saveSubtitlesWithMedia
Storing subtitles next to video files will allow them to be more easily managed.

**Type**: boolean

**Default**: `true`

### libraries.*.saveTrickplayWithMedia
Saving trickplay images into media folders will put them next to your media for easy migration and access

**Type**: boolean

**Default**: `false`

### libraries.*.seasonZeroDisplayName
What title should the 'specials' season (season 0) display?

**Type**: string

**Default**: `"Specials"`

### libraries.*.skipSubtitlesIfAudioTrackMatches
Uncheck this to ensure all videos have subtitles, regardless of audio language.

**Type**: boolean

**Default**: `false`

### libraries.*.skipSubtitlesIfEmbeddedSubtitlesPresent
Keeping text versions of subtitles will result in more efficient delivery and decrease the likelihood of video transcoding.

**Type**: boolean

**Default**: `false`

### libraries.*.subtitleDownloadLanguages

**Type**: list of string

**Default**: 
```nix
[
 "eng"
]
```

### libraries.*.subtitleFetcherOrder
Enable and rank your preferred subtitle downloaders in order of priority.

**Type**: list of string

**Default**: 
```nix
[
 "Open Subtitles"
]
```

### libraries.*.typeOptions
#### libraries.*.typeOptions.*
# encoding
## encoding.allowAv1Encoding
Whether AV1 encoding is enabled

**Type**: boolean

**Default**: `false`

## encoding.allowHevcEncoding
Whether HEVC encoding is enabled

**Type**: boolean

**Default**: `false`

## encoding.allowOnDemandMetadataBasedKeyframeExtractionForExtensions
imma be real i have no idea what this option is. Just leave it as the default

**Type**: list of string

**Default**: 
```nix
[
 "mkv"
]
```

## encoding.deinterlaceDoubleRate
Whether to enable This setting uses the field rate when deinterlacing, often referred to as bob deinterlacing, which doubles the frame rate of the video to provide full motion like what you would see when viewing interlaced video on a TV.
.

**Type**: boolean

**Default**: `false`

## encoding.deinterlaceMethod
Select the deinterlacing method to use when software transcoding interlaced content.
When hardware acceleration supporting hardware deinterlacing is enabled the hardware deinterlacer will be used instead of this setting.


**Type**: one of "yadif", "bwdif"

**Default**: `"yadif"`

## encoding.downMixAudioBoost
Boost audio when downmixing. A value of one will preserve the original volume.

**Type**: signed integer or floating point number

**Default**: `2`

## encoding.downMixStereoAlgorithm
Algorithm used to downmix multi-channel audio to stereo.

**Type**: one of "None", "Dave750", "NightmodeDialogue", "RFC7845", "AC-4"

**Default**: `"None"`

## encoding.enableAudioVbr
Whether to enable Enable VBR Audio.

**Type**: boolean

**Default**: `false`

## encoding.enableDecodingColorDepth10Hevc
Whether to enable Enable hardware decoding for HEVC 10bit.

**Type**: boolean

**Default**: `false`

## encoding.enableDecodingColorDepth10HevcRext
Whether to enable Enable hardware decoding for HEVC RExt 8/10bit.

**Type**: boolean

**Default**: `false`

## encoding.enableDecodingColorDepth10Vp9
Whether to enable Enable hardware decoding for VP9 10bit.

**Type**: boolean

**Default**: `false`

## encoding.enableDecodingColorDepth12HevcRext
Whether to enable Enable hardware decoding for HEVC RExt 12bit.

**Type**: boolean

**Default**: `false`

## encoding.enableFallbackFont
Whether to enable Enable fallback font.

**Type**: boolean

**Default**: `false`

## encoding.enableHardwareEncoding
Whether to do Hardware Acceleration

**Type**: boolean

**Default**: `true`

## encoding.enableIntelLowPowerH264HwEncoder
Whether to enable Low-Power Encoding can keep unnecessary CPU-GPU sync. On Linux they must be disabled if the i915 HuC firmware is not configured.

https://jellyfin.org/docs/general/administration/hardware-acceleration/intel/#configure-and-verify-lp-mode-on-linux
.

**Type**: boolean

**Default**: `false`

## encoding.enableIntelLowPowerHevcHwEncoder
Whether to enable Low-Power Encoding can keep unnecessary CPU-GPU sync. On Linux they must be disabled if the i915 HuC firmware is not configured.

https://jellyfin.org/docs/general/administration/hardware-acceleration/intel/#configure-and-verify-lp-mode-on-linux
.

**Type**: boolean

**Default**: `false`

## encoding.enableSegmentDeletion
Whether to enable Delete old segments after they have been downloaded by the client.
This prevents having to store the entire transcoded file on disk.
Turn this off if you experience playback issues.
.

**Type**: boolean

**Default**: `false`

## encoding.enableSubtitleExtraction
Embedded subtitles can be extracted from videos and delivered to clients in plain text, in order to help prevent video transcoding.
On some systems this can take a long time and cause video playback to stall during the extraction process.
Disable this to have embedded subtitles burned in with video transcoding when they are not natively supported by the client device.


**Type**: boolean

**Default**: `true`

## encoding.enableThrottling
Whether to enable When a transcode or remux gets far enough ahead from the current playback position, pause the process so it will consume fewer resources.
This is most useful when watching without seeking often. Turn this off if you experience playback issues.
.

**Type**: boolean

**Default**: `false`

## encoding.enableTonemapping
Whether to enable Tone-mapping can transform the dynamic range of a video from HDR to SDR while maintaining image details and colors, which are very important information for representing the original scene.
Currently works only with 10bit HDR10, HLG and DoVi videos. This requires the corresponding GPGPU runtime.
.

**Type**: boolean

**Default**: `false`

## encoding.enableVppTonemapping
Whether to enable Full Intel driver based tone-mapping. Currently works only on certain hardware with HDR10 videos. This has a higher priority compared to another OpenCL implementation.
.

**Type**: boolean

**Default**: `false`

## encoding.encoderAppPathDisplay
The path to the FFmpeg application file or folder containing FFmpeg.

**Type**: string

**Default**: `"/nix/store/qam79xcqhd994vl11n88xwdykzyirjhn-jellyfin-ffmpeg-7.0.2-9-bin"`

## encoding.encoderPreset
Pick a faster value to improve performance, or a slower value to improve quality.


**Type**: one of "auto", "veryslow", "slower", "slow", "medium", "fast", "faster", "veryfast", "superfast", "ultrafast"

**Default**: `"auto"`

## encoding.encodingThreadCount
Amount of threads used for encoding.

Set to -1 for automatic and 0 for max.


**Type**: signed integer

**Default**: `-1`

## encoding.h254Crf
The 'Constant Rate Factor' (CRF) is the default quality setting for the x264 and x265 software encoders.
You can set the values between 0 and 51, where lower values would result in better quality (at the expense of higher file sizes).
Sane values are between 18 and 28.

Hardware encoders do not use these settings.


**Type**: signed integer

**Default**: `23`

## encoding.h256Crf
The 'Constant Rate Factor' (CRF) is the default quality setting for the x264 and x265 software encoders.
You can set the values between 0 and 51, where lower values would result in better quality (at the expense of higher file sizes).
Sane values are between 18 and 28.

Hardware encoders do not use these settings.


**Type**: signed integer

**Default**: `28`

## encoding.hardwareAccelerationType
Whether or not to use hardware acceleration for transcoding.

If you misconfigure this your streams **will not work**!.
More info: https://jellyfin.org/docs/general/administration/hardware-acceleration/


**Type**: one of "none", "qsv", "amf", "nvenc", "vaapi", "rkmpp", "videotoolbox", "v4l2m2m"

**Default**: `"none"`

## encoding.hardwareDecodingCodecs
List of codec types to enable hardware decoding for.
Should only include codecs your hardware has support for.

Consult https://jellyfin.org/docs/general/administration/hardware-acceleration/ for more info.


**Type**: list of (one of "h264", "hevc", "mpeg2video", "vc1", "vp8", "vp9", "av1")

**Default**: 
```nix
[
 "h264"
 "hevc"
 "mpeg2video"
 "vc1"
]
```

## encoding.maxMuxingQueueSize
Maximum number of packets that can be buffered while waiting for all streams to initialize.
Try to increase it if you still meet "Too many packets buffered for output stream" error in FFmpeg logs.

The recommended value is `2048`.


**Type**: signed integer

**Default**: `2048`

## encoding.qsvDevice
Specify the device for Intel QSV on a multi-GPU system.
On Linux, this is the render node, e.g., /dev/dri/renderD128.
Leave blank unless you know what you are doing.


**Type**: string

**Default**: `""`

## encoding.segmentKeepSeconds
Time in seconds for which segments should be kept after they are downloaded by the client.
Only works if segment deletion is enabled.


**Type**: signed integer

**Default**: `720`

## encoding.throttleDelaySeconds
Time in seconds after which the transcoder will be throttled.
Must be large enough for the client to maintain a healthy buffer.
Only works if throttling is enabled.


**Type**: signed integer

**Default**: `180`

## encoding.tonemapingParam
Tune the tone mapping algorithm.
The recommended and default values are 0.

Recommended to leave unchanged


**Type**: signed integer or floating point number

**Default**: `0`

## encoding.tonemappingAlgorithm
Tone mapping can be fine-tuned.
If you are not familiar with these options, just keep the default.


**Type**: one of "none", "bt2390", "clip", "linear", "gamma", "reinhard", "hable", "mobius"

**Default**: `"bt2390"`

## encoding.tonemappingDesat
Apply desaturation for highlights that exceed this level of brightness.
The higher the parameter, the more color information will be preserved.
This setting helps prevent unnaturally blown-out colors for super-highlights, by (smoothly) turning into white instead.
This makes images feel more natural, at the cost of reducing information about out-of-range colors.

The recommended and default values are 0 and 0.5.


**Type**: signed integer or floating point number

**Default**: `0`

## encoding.tonemappingMode
Select the tone mapping mode.
If you experience blown out highlights try switching to the RGB mode.


**Type**: one of "auto", "max", "rgb", "lum", "itp"

**Default**: `"auto"`

## encoding.tonemappingPeak
Override signal/nominal/reference peak with this value.
Useful when the embedded peak information in display metadata is not reliable or when tone mapping from a lower range to a higher range.

The recommended and default values are 100 and 0.


**Type**: signed integer or floating point number

**Default**: `100`

## encoding.tonemappingRange
Select the output color range. Auto is the same as the input range.


**Type**: one of "auto", "tv", "pc"

**Default**: `"auto"`

## encoding.transcodingTempPath
Path for temporary transcoded files when streaming

**Type**: string

**Default**: `"/var/cache/jellyfin/transcodes"`

## encoding.vaapiDevice
This is the render node that is used for hardware acceleration.
Only used if `HardwareAccelerationType` is set to `vaapi`.


**Type**: string

**Default**: `"/dev/dri/renderD128"`

## encoding.vppTonemappingBrightness
Apply brightness gain in VPP tone mapping.

The recommended and default values are 16 and 0.


**Type**: signed integer or floating point number

**Default**: `16`

## encoding.vppTonemappingContrast
Apply contrast gain in VPP tone mapping.

Both recommended and default values are 1.


**Type**: signed integer or floating point number

**Default**: `1`
# network
## network.autoDiscovery
Enable auto discovery

**Type**: boolean

**Default**: `true`

## network.baseUrl
Add a custom subdirectory to the server URL. For example: http://example.com/<baseurl>

**Type**: string

**Default**: `""`

## network.certificatePassword
If your certificate requires a password, please enter it here.

**Type**: string

**Default**: `""`

## network.certificatePath
Path to a PKCS #12 file containing a certificate and private key to enable TLS support on a custom domain.

**Type**: string or absolute path

**Default**: `""`

## network.enableHttps
Whether to enable Enable HTTPS.

**Type**: boolean

**Default**: `false`

## network.enableIPv4
Enable IPv4 routing

**Type**: boolean

**Default**: `true`

## network.enableIPv6
Enable IPv6 routing

**Type**: boolean

**Default**: `false`

## network.enablePublishedServerUriByRequest
Whether to enable Enable published server uri by request.

**Type**: boolean

**Default**: `false`

## network.enableRemoteAccess
Enable remote access

**Type**: boolean

**Default**: `true`

## network.enableUPnP
Whether to enable Enable UPnP forwarding.

**Type**: boolean

**Default**: `false`

## network.ignoreVirtualInterfaces
Ignore virtual interfaces

**Type**: boolean

**Default**: `true`

## network.internalHttpPort
The TCP port number for the HTTP server.

**Type**: 16 bit unsigned integer; between 0 and 65535 (both inclusive)

**Default**: `8096`

## network.internalHttpsPort
The TCP port number for the HTTPS server.

**Type**: 16 bit unsigned integer; between 0 and 65535 (both inclusive)

**Default**: `8920`

## network.isRemoteIPFilterBlacklist
Whether to enable Is the remote ip filter list a blacklist or a whitelist.

**Type**: boolean

**Default**: `false`

## network.knownProxies
A list of known proxies

**Type**: list of string

**Default**: `[]`

## network.localNetworkAddresses
Whether to enable UNIMPLEMENTED.

**Type**: boolean

**Default**: `false`

## network.localNetworkSubnets
List of IP addresses or IP/netmask entries for networks that will be considered on local network when enforcing bandwidth restrictions.
If set, all other IP addresses will be considered to be on the external network and will be subject to the external bandwidth restrictions.
If left empty, only the server's subnet is considered to be on the local network.


**Type**: list of string

**Default**: `[]`

## network.publicHttpPort
The public port number that should be mapped to the local HTTP port.

**Type**: 16 bit unsigned integer; between 0 and 65535 (both inclusive)

**Default**: `8096`

## network.publicHttpsPort
The public port number that should be mapped to the local HTTPS port.

**Type**: 16 bit unsigned integer; between 0 and 65535 (both inclusive)

**Default**: `8920`

## network.publishedServerUriBySubnet
Override the URI used by Jellyfin, based on the interface, or client IP address.

For example: `["internal=http://jellyfin.example.com" "external=https://jellyfin.example.com"]` or `["all=https://jellyfin.example.com"]`


**Type**: list of string

**Default**: `[]`

## network.remoteIpFilter
List of IP addresses or IP/netmask entries for networks that will be allowed to connect remotely.
If left empty, all remote addresses will be allowed.


**Type**: list of string

**Default**: `[]`

## network.requireHttps
Whether to enable Require HTTPS.

**Type**: boolean

**Default**: `false`

## network.virtualInterfaceNames
List of virtual interface names

**Type**: list of string

**Default**: 
```nix
[
 "veth"
]
```
# users
## users.*
### users.*.audioLanguagePreference
The audio language preference. Defaults to 'Any Language'

**Type**: null or string

**Default**: `<null>`

### users.*.authenticationProviderId

**Type**: string

**Default**: `"Jellyfin.Server.Implementations.Users.DefaultAuthenticationProvider"`

### users.*.castReceiverId

**Type**: string

**Default**: `"F007D354"`

### users.*.displayCollectionsView
Whether to show the Collections View

**Type**: boolean

**Default**: `false`

### users.*.displayMissingEpisodes
Whether to show missing episodes

**Type**: boolean

**Default**: `false`

### users.*.enableAutoLogin

**Type**: boolean

**Default**: `false`

### users.*.enableLocalPassword

**Type**: boolean

**Default**: `false`

### users.*.enableNextEpisodeAutoPlay
Automatically play the next episode

**Type**: boolean

**Default**: `true`

### users.*.enableUserPreferenceAccess

**Type**: boolean

**Default**: `true`

### users.*.hashedPassword
A pbkdf2-sha512 hash of the users password. Can be generated with the genhash flake app.
See docs for `HashedPasswordFile` for details on how to generate a hash


**Type**: null or string

**Default**: `<null>`

### users.*.hashedPasswordFile
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


**Type**: null or absolute path

**Default**: `<null>`

### users.*.hidePlayedInLatest
Whether to hide already played titles in the 'Latest' section

**Type**: boolean

**Default**: `true`

### users.*.id
The ID of the user

**Type**: null or string

**Default**: `<null>`

### users.*.internalId
The index of the user in the database. Be careful setting this option. 1 indexed.

**Type**: null or signed integer

**Default**: `<null>`

### users.*.invalidLoginAttemptCount

**Type**: signed integer

**Default**: `0`

### users.*.lastActivityDate

**Type**: null or string

**Default**: `<null>`

### users.*.lastLoginDate

**Type**: null or string

**Default**: `<null>`

### users.*.loginAttemptsBeforeLockout
The number of login attempts the user can make before they are locked out. 0 for default (3 for normal users, 5 for admins). null for unlimited

**Type**: null or signed integer

**Default**: `3`

### users.*.maxActiveSessions
The maximum number of active sessions the user can have at once. 0 for unlimited

**Type**: signed integer

**Default**: `0`

### users.*.maxParentalAgeRating

**Type**: null or signed integer

**Default**: `<null>`

### users.*.mustUpdatePassword

**Type**: signed integer

**Default**: `0`

### users.*.mutable
Functions like mutableUsers in NixOS users.users."user"
If true, the first time the user is created, all configured options
are overwritten. Any modifications from the GUI will take priority,
and no nix configuration changes will have any effect.
If false however, all options are overwritten as specified in the nix configuration,
which means any change through the Jellyfin GUI will have no effect after a rebuild.


**Type**: boolean

**Default**: `true`

### users.*.password

**Type**: null or string

**Default**: `<null>`

### users.*.passwordResetProviderId

**Type**: string

**Default**: `"Jellyfin.Server.Implementations.Users.DefaultPasswordResetProvider"`

### users.*.permissions
#### users.*.permissions.enableAllChannels
Whether the user has access to all channels

**Type**: boolean

**Default**: `true`

#### users.*.permissions.enableAllDevices
Whether the user has access to all devices

**Type**: boolean

**Default**: `true`

#### users.*.permissions.enableAllFolders
Whether the user has access to all folders

**Type**: boolean

**Default**: `true`

#### users.*.permissions.enableAudioPlaybackTranscoding
Whether the server should transcode audio for the user if requested

**Type**: boolean

**Default**: `true`

#### users.*.permissions.enableCollectionManagement
Whether the user can create, modify and delete collections

**Type**: boolean

**Default**: `false`

#### users.*.permissions.enableContentDeletion
Whether the user can delete content

**Type**: boolean

**Default**: `false`

#### users.*.permissions.enableContentDownloading
Whether the user can download content

**Type**: boolean

**Default**: `true`

#### users.*.permissions.enableLiveTvAccess
Whether the user can access live tv

**Type**: boolean

**Default**: `true`

#### users.*.permissions.enableLiveTvManagement
Whether the user can manage live tv

**Type**: boolean

**Default**: `true`

#### users.*.permissions.enableLyricManagement
Whether the user can edit lyrics

**Type**: boolean

**Default**: `false`

#### users.*.permissions.enableMediaConversion
Whether the user can do media conversion

**Type**: boolean

**Default**: `true`

#### users.*.permissions.enableMediaPlayback
Whether the user can play media

**Type**: boolean

**Default**: `true`

#### users.*.permissions.enablePlaybackRemuxing
Whether the user is permitted to do playback remuxing

**Type**: boolean

**Default**: `true`

#### users.*.permissions.enablePublicSharing
Whether to enable public sharing for the user

**Type**: boolean

**Default**: `true`

#### users.*.permissions.enableRemoteAccess
Whether the user can access the server remotely

**Type**: boolean

**Default**: `true`

#### users.*.permissions.enableRemoteControlOfOtherUsers
Whether the user can remotely control other users

**Type**: boolean

**Default**: `false`

#### users.*.permissions.enableSharedDeviceControl
Whether the user can control shared devices

**Type**: boolean

**Default**: `true`

#### users.*.permissions.enableSubtitleManagement
Whether the user can edit subtitles

**Type**: boolean

**Default**: `false`

#### users.*.permissions.enableSyncTranscoding
Whether to enable sync transcoding for the user

**Type**: boolean

**Default**: `true`

#### users.*.permissions.enableVideoPlaybackTranscoding
Whether the server should transcode video for the user if requested

**Type**: boolean

**Default**: `true`

#### users.*.permissions.forceRemoteSourceTranscoding
Whether the server should force transcoding on remote connections for the user

**Type**: boolean

**Default**: `false`

#### users.*.permissions.isAdministrator
Whether the user is an administrator

**Type**: boolean

**Default**: `false`

#### users.*.permissions.isDisabled
Whether the user is disabled

**Type**: boolean

**Default**: `false`

#### users.*.permissions.isHidden
Whether the user is hidden

**Type**: boolean

**Default**: `true`

### users.*.playDefaultAudioTrack

**Type**: boolean

**Default**: `true`

### users.*.preferences
#### users.*.preferences.enabledLibraries
A list of libraries this user as access to.
If it is empty, it means that the user has access to all libraries.
The libraries are specified by the library name specified in
`services.declarative-jellyfin.libraries.<name>`


**Type**: list of string

**Default**: `[]`

### users.*.rememberAudioSelections

**Type**: boolean

**Default**: `true`

### users.*.rememberSubtitleSelections

**Type**: boolean

**Default**: `true`

### users.*.remoteClientBitrateLimit
0 for unlimited

**Type**: signed integer

**Default**: `0`

### users.*.rowVersion

**Type**: signed integer

**Default**: `0`

### users.*.subtitleLanguagePreference
The subtitle language preference. Defaults to 'Any Language'

**Type**: null or string

**Default**: `<null>`

### users.*.subtitleMode
Default: The default subtitle playback mode.
Always: Always show subtitles.
OnlyForced: Only show forced subtitles.
None: Don't show subtitles.
Smart: Only show subtitles when the current audio stream is in a different language.


**Type**: one of "default", "always", "onlyForced", "none", "smart"

**Default**: `"default"`

### users.*.syncPlayAccess
Whether or not this user has access to SyncPlay

**Type**: boolean

**Default**: `false`
