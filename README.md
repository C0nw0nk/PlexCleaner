# PlexCleaner

PlexCleaner Utility to optimize media files for Direct Play in Plex, Emby, Jellyfin it will scan through the media server directory and automatically convert files to mkv for direct playback the reason this is a good idea is it saves your NAS or plex host effort having to transcode media when all media is direct play ready.

# Usage

Just edit the folder paths in the settings section of `PlexCleaner.cmd` then run `PlexCleaner.cmd` and enjoy saving your server CPU consumption and effort having to transcode videos in future when everything can be instantly ready for direct playback compatibility.



# Other Optional useful tools

### H265 X265 Encode Entire media folders

I made this to reduce the size of my plex/emby library since allot of h264/x264 encoded videos was 30GB in size each by doing this i made 30gb videos 2gb in size and 2gb videos became 600mb it is a huge saving allowing me to add more media to the server.

https://github.com/C0nw0nk/PlexCleaner-H265

### Disable Forced Subtitles

On plex / Emby i found videos trying to transcode because of forced subtitles flags even so i made this to fix that.

https://github.com/C0nw0nk/DisableForcedSubtitles

#### Extra Features of Disable Forced Subtitles

```
Option to Remove chapter markers

Option to Remove tags and global tags
```

### Remove Subtitles

This will remove specified codecs of subtitles from media folders you choose. For example IMAGE based subtitles xsub vobsubs will cause media to transcode when selected by removing these subtitles you can instead have plex emby jellyfin rely on using opensubtitles what are text based subtitiles for media that will not cause transcoding.

https://github.com/C0nw0nk/RemoveSubtitles

### TV Season Ordering

On plex / emby i had a issue with tv series being numbered from 1-100 and having no season or information so i moved them to season folders and made this to rename the videos in order.

https://github.com/C0nw0nk/TV-Season-Ordering

### AV1 

https://github.com/C0nw0nk/PlexCleaner-AV1

### VP9

https://github.com/C0nw0nk/PlexCleaner-VP9
