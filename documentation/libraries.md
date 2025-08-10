# libraries
## libraries.*
### libraries.*.allowEmbeddedSubtitles
Disable subtitles that are packaged within media containers. Requires a full library refresh.

**Type**: one of "AllowAll", "AllowText", "AllowImages", "AllowNone"
**Default: `"AllowAll"`

### libraries.*.automaticRefreshIntervalDays
How often to automatically refresh metadata from the internet. (in days)

**Type**: signed integer
**Default: `30`

### libraries.*.automaticallyAddToCollection
Toggles whether or not similar series/shows (ie. sequals or spinoffs) will be grouped in collections.

**Type**: boolean
**Default: `false`

### libraries.*.contentType
The type of content this library contains. Used for setting the default image/metadata fetchers.


**Type**: one of "movies", "music", "tvshows", "books", "homevideos", "musicvideos", "boxsets"


### libraries.*.customTagDelimiters

**Type**: list of string
**Default: 
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
**Default: `[]`

### libraries.*.disabledLocalMetadataReaders

**Type**: list of string
**Default: `[]`

### libraries.*.disabledLyricFetchers

**Type**: list of string
**Default: `[]`

### libraries.*.disabledMediaSegmentProviders

**Type**: list of string
**Default: `[]`

### libraries.*.disabledSubtitleFetchers
What order should local metadata readers be prioritised

**Type**: list of string
**Default: `[]`

### libraries.*.enableAutomaticSeriesGrouping
Series that are spread across multiple folders within this library will be automatically merged into a single series.

**Type**: boolean
**Default: `false`

### libraries.*.enableChapterImageExtraction
Whether or not to extract frames from the media to show as previews for chapters

**Type**: boolean
**Default: `false`

### libraries.*.enableEmbeddedEpisodeInfos

**Type**: boolean
**Default: `false`

### libraries.*.enableEmbeddedExtraTitles
Use the episode information from the embedded metadata if available.

**Type**: boolean
**Default: `false`

### libraries.*.enableEmbeddedTitles
Whether or not to use the title embedded in the file if no internet metadata is available (if any is embedded)

**Type**: boolean
**Default: `false`

### libraries.*.enableLUFSScan

**Type**: boolean
**Default: `true`

### libraries.*.enablePhotos
Whether or not media in this library should display photos

**Type**: boolean
**Default: `true`

### libraries.*.enableRealtimeMonitor
Changes to files will be processed immediately on supported file systems

**Type**: boolean
**Default: `true`

### libraries.*.enableTrickplayImageExtraction
Enables trickplay image generation for previews when skipping in media

**Type**: boolean
**Default: `false`

### libraries.*.enabled
Whether or not this library is enabled

**Type**: boolean
**Default: `true`

### libraries.*.extractChapterImagesDuringLibraryScan
Whether or not to extract frames for previews for chapters during library scans

**Type**: boolean
**Default: `false`

### libraries.*.extractTrickplayImagesDuringLibraryScan
Whether or not trickplay images should be extracted during the library scan

**Type**: boolean
**Default: `false`

### libraries.*.localMetadataReaderOrder
What order should local metadata readers be prioritised

**Type**: list of string
**Default: 
```nix
[
 "Nfo"
]
```

### libraries.*.lyricFetcherOrder

**Type**: list of string
**Default: `[]`

### libraries.*.mediaSegmentProvideOrder

**Type**: list of string
**Default: `[]`

### libraries.*.metadataCountryCode

**Type**: string
**Default: `""`

### libraries.*.metadataSavers
Pick the file formats to use when saving your metadata.

**Type**: list of string
**Default: `[]`

### libraries.*.pathInfos
List of paths for media in this library

**Type**: list of string


### libraries.*.preferredMetadataLanguage
What language should metadata be fetched for? Affects titles, descriptions, etc.

**Type**: string
**Default: `"en"`

### libraries.*.requirePerfectSubtitleMatch

**Type**: boolean
**Default: `true`

### libraries.*.saveLocalMetadata

**Type**: boolean
**Default: `false`

### libraries.*.saveLyricsWithMedia
Saving lyrics into media folders will put them next to your media for easy migration and access

**Type**: boolean
**Default: `false`

### libraries.*.saveSubtitlesWithMedia
Storing subtitles next to video files will allow them to be more easily managed.

**Type**: boolean
**Default: `true`

### libraries.*.saveTrickplayWithMedia
Saving trickplay images into media folders will put them next to your media for easy migration and access

**Type**: boolean
**Default: `false`

### libraries.*.seasonZeroDisplayName
What title should the 'specials' season (season 0) display?

**Type**: string
**Default: `"Specials"`

### libraries.*.skipSubtitlesIfAudioTrackMatches
Uncheck this to ensure all videos have subtitles, regardless of audio language.

**Type**: boolean
**Default: `false`

### libraries.*.skipSubtitlesIfEmbeddedSubtitlesPresent
Keeping text versions of subtitles will result in more efficient delivery and decrease the likelihood of video transcoding.

**Type**: boolean
**Default: `false`

### libraries.*.subtitleDownloadLanguages

**Type**: list of string
**Default: 
```nix
[
 "eng"
]
```

### libraries.*.subtitleFetcherOrder
Enable and rank your preferred subtitle downloaders in order of priority.

**Type**: list of string
**Default: 
```nix
[
 "Open Subtitles"
]
```

### libraries.*.typeOptions
#### libraries.*.typeOptions.*
