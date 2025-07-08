This documentation is auto-generated
# services.declarative-jellyfin.system
## services.declarative-jellyfin.system.UICulture

**Type**: string

**Default**: 
```nix
"en-US"
```

## services.declarative-jellyfin.system.activityLogRetentionDays

**Type**: signed integer

**Default**: 
```nix
30
```

## services.declarative-jellyfin.system.allowClientLogUpload

**Type**: boolean

**Default**: 
```nix
true
```

## services.declarative-jellyfin.system.cachePath
Specify a custom location for server cache files such as images.


**Type**: string

**Default**: 
```nix
"/var/cache/jellyfin"
```

## services.declarative-jellyfin.system.castReceiverApplications

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

## services.declarative-jellyfin.system.chapterImageResolution
The resolution of the extracted chapter images.
Changing this will have no effect on existing dummy chapters.


**Type**: one of "MatchSource", "2160p", "1440p", "1080p", "720p", "480p", "360p", "240p", "144p"

**Default**: 
```nix
"MatchSource"
```

## services.declarative-jellyfin.system.codecsUsed

**Type**: list of string

**Default**: 
```nix
[]
```

## services.declarative-jellyfin.system.contentTypes

**Type**: list of string

**Default**: 
```nix
[]
```

## services.declarative-jellyfin.system.corsHosts

**Type**: list of string

**Default**: 
```nix
[
"*"
]
```

## services.declarative-jellyfin.system.disableLiveTvChannelUserDataName

**Type**: boolean

**Default**: 
```nix
true
```

## services.declarative-jellyfin.system.displaySpecialsWithinSeasons

**Type**: boolean

**Default**: 
```nix
true
```

## services.declarative-jellyfin.system.dummyChapterDuration

**Type**: signed integer

**Default**: 
```nix
0
```

## services.declarative-jellyfin.system.enableCaseSensitiveItemIds

**Type**: boolean

**Default**: 
```nix
true
```

## services.declarative-jellyfin.system.enableExternalContentInSuggestions

**Type**: boolean

**Default**: 
```nix
true
```

## services.declarative-jellyfin.system.enableFolderView
Whether to enable .

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.system.enableGroupingIntoCollections
Whether to enable .

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.system.enableMetrics
Whether to enable metrics.

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.system.enableNormalizedItemByNameIds

**Type**: boolean

**Default**: 
```nix
true
```

## services.declarative-jellyfin.system.enableSlowResponseWarning

**Type**: boolean

**Default**: 
```nix
true
```

## services.declarative-jellyfin.system.imageExtractionTimeoutMs
Leave at 0 for no timeout

**Type**: signed integer

**Default**: 
```nix
0
```

## services.declarative-jellyfin.system.imageSavingConvention
i got no idea what this is

**Type**: value "Legacy" (singular enum)

**Default**: 
```nix
"Legacy"
```

## services.declarative-jellyfin.system.inactiveSessionThreshhold

**Type**: signed integer

**Default**: 
```nix
0
```

## services.declarative-jellyfin.system.isPortAuthorized

**Type**: boolean

**Default**: 
```nix
true
```

## services.declarative-jellyfin.system.isStartupWizardCompleted
Controls whether or not Declarative Jellyfin will mark the startup wizard as completed.
Set to `false` to show the startup wizard when visiting jellyfin (not recommended as this
will happen every time jellyfin is restarted)


**Type**: boolean

**Default**: 
```nix
true
```

## services.declarative-jellyfin.system.libraryMetadataRefreshConcurrency
Maximum number of parallel tasks during library scans.
Setting this to 0 will choose a limit based on your systems core count.
WARNING: Setting this number too high may cause issues with network file systems; if you encounter problems lower this number.


**Type**: signed integer

**Default**: 
```nix
0
```

## services.declarative-jellyfin.system.libraryMonitorDelay

**Type**: signed integer

**Default**: 
```nix
60
```

## services.declarative-jellyfin.system.libraryScanFanoutConcurrency
Maximum number of parallel tasks during library scans.
Setting this to 0 will choose a limit based on your systems core count.
WARNING: Setting this number too high may cause issues with network file systems; if you encounter problems lower this number.


**Type**: signed integer

**Default**: 
```nix
0
```

## services.declarative-jellyfin.system.libraryUpdateDuration

**Type**: signed integer

**Default**: 
```nix
30
```

## services.declarative-jellyfin.system.logFileRetentionDays

**Type**: signed integer

**Default**: 
```nix
3
```

## services.declarative-jellyfin.system.maxAudiobookResume
Titles are assumed fully played if stopped when the remaining duration is less than this value.


**Type**: signed integer

**Default**: 
```nix
5
```

## services.declarative-jellyfin.system.maxResumePct
Titles are assumed fully played if stopped after this time.


**Type**: signed integer

**Default**: 
```nix
90
```

## services.declarative-jellyfin.system.metadataCountryCode
Country code for language. Determines stuff like dates, comma placement etc.


**Type**: string

**Default**: 
```nix
"US"
```

## services.declarative-jellyfin.system.metadataOptions

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

## services.declarative-jellyfin.system.metadataPath
Specify a custom location for downloaded artwork and metadata.


**Type**: string

**Default**: 
```nix
"/var/lib/jellyfin/metadata"
```

## services.declarative-jellyfin.system.minAudiobookResume
Titles are assumed unplayed if stopped before this time.


**Type**: signed integer

**Default**: 
```nix
5
```

## services.declarative-jellyfin.system.minResumeDurationSeconds
The shortest video length in seconds that will save playback location and let you resume.


**Type**: signed integer

**Default**: 
```nix
300
```

## services.declarative-jellyfin.system.minResumePct
Titles are assumed unplayed if stopped before this time.


**Type**: signed integer

**Default**: 
```nix
5
```

## services.declarative-jellyfin.system.parallelImageEncodingLimit
Maximum number of image encodings that are allowed to run in parallel.
Setting this to 0 will choose a limit based on your systems core count.


**Type**: signed integer

**Default**: 
```nix
0
```

## services.declarative-jellyfin.system.pathSubstitutions

**Type**: list of string

**Default**: 
```nix
[]
```

## services.declarative-jellyfin.system.pluginRepositories
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

## services.declarative-jellyfin.system.preferredMetadataLanguage
Display language of jellyfin.

**Type**: string

**Default**: 
```nix
"en"
```

## services.declarative-jellyfin.system.quickConnectAvailable
Whether or not to enable quickconnect


**Type**: boolean

**Default**: 
```nix
true
```

## services.declarative-jellyfin.system.remoteClientBitrateLimit

**Type**: signed integer

**Default**: 
```nix
0
```

## services.declarative-jellyfin.system.removeOldPlugins

**Type**: boolean

**Default**: 
```nix
true
```

## services.declarative-jellyfin.system.saveMetadataHidden
Whether to enable .

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.system.serverName
This name will be used to identify the server and will default to the server's hostname.


**Type**: string

**Default**: 
```nix
"config.networking.hostName"
```

## services.declarative-jellyfin.system.skipDeserializationForBasicTypes

**Type**: boolean

**Default**: 
```nix
true
```

## services.declarative-jellyfin.system.slowResponseThresholdMs
How slow (in ms) would a response have to be before a warning is shown

**Type**: signed integer

**Default**: 
```nix
500
```

## services.declarative-jellyfin.system.sortRemoveCharacters

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

## services.declarative-jellyfin.system.sortRemoveWords

**Type**: list of string

**Default**: 
```nix
[
"the"
"a"
"an"
]
```

## services.declarative-jellyfin.system.sortReplaceCharacters

**Type**: list of string

**Default**: 
```nix
[
"."
"+"
"%"
]
```

## services.declarative-jellyfin.system.trickplayOptions
### services.declarative-jellyfin.system.trickplayOptions.enableHwAcceleration
Whether to enable Enable hardware acceleration.

**Type**: boolean

**Default**: 
```nix
false
```

### services.declarative-jellyfin.system.trickplayOptions.enableHwEncoding
Whether to enable Currently only available on QSV, VA-API, VideoToolbox and RKMPP, this option has no effect on other hardware acceleration methods..

**Type**: boolean

**Default**: 
```nix
false
```

### services.declarative-jellyfin.system.trickplayOptions.enableKeyFrameOnlyExtraction
Whether to enable Extract key frames only for significantly faster processing with less accurate timing.
If the configured hardware decoder does not support this mode, will use the software decoder instead.
.

**Type**: boolean

**Default**: 
```nix
false
```

### services.declarative-jellyfin.system.trickplayOptions.interval
Interval of time (ms) between each new trickplay image.


**Type**: signed integer

**Default**: 
```nix
10000
```

### services.declarative-jellyfin.system.trickplayOptions.jpegQuality
The JPEG compression quality for trickplay images.


**Type**: integer between 0 and 100 (both inclusive)

**Default**: 
```nix
90
```

### services.declarative-jellyfin.system.trickplayOptions.processPriority
Setting this lower or higher will determine how the CPU prioritizes the ffmpeg trickplay generation process in relation to other processes.
If you notice slowdown while generating trickplay images but don't want to fully stop their generation, try lowering this as well as the thread count.


**Type**: one of "High", "AboveNormal", "Normal", "BelowNormal", "Idle"

**Default**: 
```nix
"BelowNormal"
```

### services.declarative-jellyfin.system.trickplayOptions.processThreads
The number of threads to pass to the '-threads' argument of ffmpeg.


**Type**: signed integer

**Default**: 
```nix
1
```

### services.declarative-jellyfin.system.trickplayOptions.qscale
The quality scale of images output by ffmpeg, with 2 being the highest quality and 31 being the lowest.


**Type**: integer between 2 and 31 (both inclusive)

**Default**: 
```nix
4
```

### services.declarative-jellyfin.system.trickplayOptions.scanBehavior
The default behavior is non blocking, which will add media to the library before trickplay generation is done. Blocking will ensure trickplay files are generated before media is added to the library, but will make scans significantly longer.


**Type**: one of "NonBlocking", "Blocking"

**Default**: 
```nix
"NonBlocking"
```

### services.declarative-jellyfin.system.trickplayOptions.tileHeight
Maximum number of images per tile in the X direction.


**Type**: signed integer

**Default**: 
```nix
10
```

### services.declarative-jellyfin.system.trickplayOptions.tileWidth
Maximum number of images per tile in the X direction.


**Type**: signed integer

**Default**: 
```nix
10
```

### services.declarative-jellyfin.system.trickplayOptions.widthResolutions
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
# services.declarative-jellyfin.libraries
Library configuration

**Type**: attribute set of (submodule)

**Default**: 
```nix
{

}
```
# services.declarative-jellyfin.encoding
## services.declarative-jellyfin.encoding.allowAv1Encoding
Whether AV1 encoding is enabled

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.encoding.allowHevcEncoding
Whether HEVC encoding is enabled

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.encoding.allowOnDemandMetadataBasedKeyframeExtractionForExtensions
imma be real i have no idea what this option is. Just leave it as the default

**Type**: list of string

**Default**: 
```nix
[
"mkv"
]
```

## services.declarative-jellyfin.encoding.deinterlaceDoubleRate
Whether to enable This setting uses the field rate when deinterlacing, often referred to as bob deinterlacing, which doubles the frame rate of the video to provide full motion like what you would see when viewing interlaced video on a TV.
.

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.encoding.deinterlaceMethod
Select the deinterlacing method to use when software transcoding interlaced content.
When hardware acceleration supporting hardware deinterlacing is enabled the hardware deinterlacer will be used instead of this setting.


**Type**: one of "yadif", "bwdif"

**Default**: 
```nix
"yadif"
```

## services.declarative-jellyfin.encoding.downMixAudioBoost
Boost audio when downmixing. A value of one will preserve the original volume.

**Type**: signed integer or floating point number

**Default**: 
```nix
2
```

## services.declarative-jellyfin.encoding.downMixStereoAlgorithm
Algorithm used to downmix multi-channel audio to stereo.

**Type**: one of "None", "Dave750", "NightmodeDialogue", "RFC7845", "AC-4"

**Default**: 
```nix
"None"
```

## services.declarative-jellyfin.encoding.enableAudioVbr
Whether to enable Enable VBR Audio.

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.encoding.enableDecodingColorDepth10Hevc
Whether to enable Enable hardware decoding for HEVC 10bit.

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.encoding.enableDecodingColorDepth10HevcRext
Whether to enable Enable hardware decoding for HEVC RExt 8/10bit.

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.encoding.enableDecodingColorDepth10Vp9
Whether to enable Enable hardware decoding for VP9 10bit.

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.encoding.enableDecodingColorDepth12HevcRext
Whether to enable Enable hardware decoding for HEVC RExt 12bit.

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.encoding.enableFallbackFont
Whether to enable Enable fallback font.

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.encoding.enableHardwareEncoding
Whether to do Hardware Acceleration

**Type**: boolean

**Default**: 
```nix
true
```

## services.declarative-jellyfin.encoding.enableIntelLowPowerH264HwEncoder
Whether to enable Low-Power Encoding can keep unnecessary CPU-GPU sync. On Linux they must be disabled if the i915 HuC firmware is not configured.

https://jellyfin.org/docs/general/administration/hardware-acceleration/intel/#configure-and-verify-lp-mode-on-linux
.

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.encoding.enableIntelLowPowerHevcHwEncoder
Whether to enable Low-Power Encoding can keep unnecessary CPU-GPU sync. On Linux they must be disabled if the i915 HuC firmware is not configured.

https://jellyfin.org/docs/general/administration/hardware-acceleration/intel/#configure-and-verify-lp-mode-on-linux
.

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.encoding.enableSegmentDeletion
Whether to enable Delete old segments after they have been downloaded by the client.
This prevents having to store the entire transcoded file on disk.
Turn this off if you experience playback issues.
.

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.encoding.enableSubtitleExtraction
Embedded subtitles can be extracted from videos and delivered to clients in plain text, in order to help prevent video transcoding.
On some systems this can take a long time and cause video playback to stall during the extraction process.
Disable this to have embedded subtitles burned in with video transcoding when they are not natively supported by the client device.


**Type**: boolean

**Default**: 
```nix
true
```

## services.declarative-jellyfin.encoding.enableThrottling
Whether to enable When a transcode or remux gets far enough ahead from the current playback position, pause the process so it will consume fewer resources.
This is most useful when watching without seeking often. Turn this off if you experience playback issues.
.

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.encoding.enableTonemapping
Whether to enable Tone-mapping can transform the dynamic range of a video from HDR to SDR while maintaining image details and colors, which are very important information for representing the original scene.
Currently works only with 10bit HDR10, HLG and DoVi videos. This requires the corresponding GPGPU runtime.
.

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.encoding.enableVppTonemapping
Whether to enable Full Intel driver based tone-mapping. Currently works only on certain hardware with HDR10 videos. This has a higher priority compared to another OpenCL implementation.
.

**Type**: boolean

**Default**: 
```nix
false
```

## services.declarative-jellyfin.encoding.encoderAppPathDisplay
The path to the FFmpeg application file or folder containing FFmpeg.

**Type**: string

**Default**: 
```nix
"/nix/store/hjhiyw52n41h58bgbx5mziaj277a6v7b-jellyfin-ffmpeg-7.1.1-6-bin"
```

## services.declarative-jellyfin.encoding.encoderPreset
Pick a faster value to improve performance, or a slower value to improve quality.


**Type**: one of "auto", "veryslow", "slower", "slow", "medium", "fast", "faster", "veryfast", "superfast", "ultrafast"

**Default**: 
```nix
"auto"
```

## services.declarative-jellyfin.encoding.encodingThreadCount
Amount of threads used for encoding.

Set to -1 for automatic and 0 for max.


**Type**: signed integer

**Default**: 
```nix
-1
```

## services.declarative-jellyfin.encoding.h254Crf
The 'Constant Rate Factor' (CRF) is the default quality setting for the x264 and x265 software encoders.
You can set the values between 0 and 51, where lower values would result in better quality (at the expense of higher file sizes).
Sane values are between 18 and 28.

Hardware encoders do not use these settings.


**Type**: signed integer

**Default**: 
```nix
23
```

## services.declarative-jellyfin.encoding.h256Crf
The 'Constant Rate Factor' (CRF) is the default quality setting for the x264 and x265 software encoders.
You can set the values between 0 and 51, where lower values would result in better quality (at the expense of higher file sizes).
Sane values are between 18 and 28.

Hardware encoders do not use these settings.


**Type**: signed integer

**Default**: 
```nix
28
```

## services.declarative-jellyfin.encoding.hardwareAccelerationType
Whether or not to use hardware acceleration for transcoding.

If you misconfigure this your streams **will not work**!.
More info: https://jellyfin.org/docs/general/administration/hardware-acceleration/


**Type**: one of "none", "qsv", "amf", "nvenc", "vaapi", "rkmpp", "videotoolbox", "v4l2m2m"

**Default**: 
```nix
"none"
```

## services.declarative-jellyfin.encoding.hardwareDecodingCodecs
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

## services.declarative-jellyfin.encoding.maxMuxingQueueSize
Maximum number of packets that can be buffered while waiting for all streams to initialize.
Try to increase it if you still meet "Too many packets buffered for output stream" error in FFmpeg logs.

The recommended value is `2048`.


**Type**: signed integer

**Default**: 
```nix
2048
```

## services.declarative-jellyfin.encoding.qsvDevice
Specify the device for Intel QSV on a multi-GPU system.
On Linux, this is the render node, e.g., /dev/dri/renderD128.
Leave blank unless you know what you are doing.


**Type**: string

**Default**: 
```nix
""
```

## services.declarative-jellyfin.encoding.segmentKeepSeconds
Time in seconds for which segments should be kept after they are downloaded by the client.
Only works if segment deletion is enabled.


**Type**: signed integer

**Default**: 
```nix
720
```

## services.declarative-jellyfin.encoding.throttleDelaySeconds
Time in seconds after which the transcoder will be throttled.
Must be large enough for the client to maintain a healthy buffer.
Only works if throttling is enabled.


**Type**: signed integer

**Default**: 
```nix
180
```

## services.declarative-jellyfin.encoding.tonemapingParam
Tune the tone mapping algorithm.
The recommended and default values are 0.

Recommended to leave unchanged


**Type**: signed integer or floating point number

**Default**: 
```nix
0
```

## services.declarative-jellyfin.encoding.tonemappingAlgorithm
Tone mapping can be fine-tuned.
If you are not familiar with these options, just keep the default.


**Type**: one of "none", "bt2390", "clip", "linear", "gamma", "reinhard", "hable", "mobius"

**Default**: 
```nix
"bt2390"
```

## services.declarative-jellyfin.encoding.tonemappingDesat
Apply desaturation for highlights that exceed this level of brightness.
The higher the parameter, the more color information will be preserved.
This setting helps prevent unnaturally blown-out colors for super-highlights, by (smoothly) turning into white instead.
This makes images feel more natural, at the cost of reducing information about out-of-range colors.

The recommended and default values are 0 and 0.5.


**Type**: signed integer or floating point number

**Default**: 
```nix
0
```

## services.declarative-jellyfin.encoding.tonemappingMode
Select the tone mapping mode.
If you experience blown out highlights try switching to the RGB mode.


**Type**: one of "auto", "max", "rgb", "lum", "itp"

**Default**: 
```nix
"auto"
```

## services.declarative-jellyfin.encoding.tonemappingPeak
Override signal/nominal/reference peak with this value.
Useful when the embedded peak information in display metadata is not reliable or when tone mapping from a lower range to a higher range.

The recommended and default values are 100 and 0.


**Type**: signed integer or floating point number

**Default**: 
```nix
100
```

## services.declarative-jellyfin.encoding.tonemappingRange
Select the output color range. Auto is the same as the input range.


**Type**: one of "auto", "tv", "pc"

**Default**: 
```nix
"auto"
```

## services.declarative-jellyfin.encoding.transcodingTempPath
Path for temporary transcoded files when streaming

**Type**: string

**Default**: 
```nix
"/var/cache/jellyfin/transcodes"
```

## services.declarative-jellyfin.encoding.vaapiDevice
This is the render node that is used for hardware acceleration.
Only used if `HardwareAccelerationType` is set to `vaapi`.


**Type**: string

**Default**: 
```nix
"/dev/dri/renderD128"
```

## services.declarative-jellyfin.encoding.vppTonemappingBrightness
Apply brightness gain in VPP tone mapping.

The recommended and default values are 16 and 0.


**Type**: signed integer or floating point number

**Default**: 
```nix
16
```

## services.declarative-jellyfin.encoding.vppTonemappingContrast
Apply contrast gain in VPP tone mapping.

Both recommended and default values are 1.


**Type**: signed integer or floating point number

**Default**: 
```nix
1
```
