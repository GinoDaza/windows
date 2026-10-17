# Download and trim YouTube videos with yt-dlp and ffmpeg (Windows)

## Setup

Download the following files:

- `yt-dlp.exe`: https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe
- `ffmpeg.exe`: https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip (extract only `bin/ffmpeg.exe` from the ZIP)

Put both files in the same folder, then open a terminal in that folder and use the commands below.

## 1. Download and trim videos

Download a full video in good quality (default format):

```
yt-dlp "https://www.youtube.com/watch?v=VIDEO_ID" -o video.webm
```

Trim a segment of the video:

```
ffmpeg -ss START -t DURATION -i video.webm -y -c copy clip.mp4
```

Download directly as mp4 (good compatibility, best reasonable quality):

```
yt-dlp -f "bv*+ba[ext=m4a]/b[ext=mp4]" --merge-output-format mp4 "https://www.youtube.com/watch?v=VIDEO_ID"
```

## 2. Prepare a video for web and iPhone compatibility

If you already have an mp4 and want it to work without problems on iOS, Safari or web pages.

Remove the audio and optimize for maximum compatibility:

```
ffmpeg -ss START -t DURATION -i video.mp4 -vcodec libx264 -an -movflags +faststart -profile:v baseline -level 3.0 output.mp4
```

If the result is too big, set a quality with `-crf`. Typical values: 23 is good quality, 28 is more compressed, and 30+ shows visible quality loss. Try values between 18 and 28 (higher compresses more) and see which works best:

```
ffmpeg -ss START -t DURATION -i video.mp4 -vcodec libx264 -crf 28 -an -movflags +faststart -profile:v baseline -level 3.0 output.mp4
ffmpeg -ss START -t DURATION -i video.mp4 -vf scale=720:-2 -vcodec libx264 -crf 25 -preset slow -an -movflags +faststart -profile:v baseline -level 3.0 output.mp4
```

The output works correctly on iPhones, mobile browsers and standard HTML web players.
