#! /usr/bin/env bash

cd $DASH_SEGMENT_INPUT_DIR

HLS_OPTS='-hls_time 10 -hls_list_size 30'
VIDEO_PRESET_OPTS='-vcodec libx264 -vprofile baseline -level 31 -keyint_min 24 -g 24 -r 24 -an'
AUDIO_PRESET_OPTS='-vn -acodec aac -strict -2 -ar 48000 -ac 2'

rm -f *.m3u8
rm -f *.ts

$DASH_VLC -I dummy -L $DASH_SOURCE_INPUT_FILE \
  --sout "#transcode{vcodec=h264,scale=1,venc=x264{repeat-headers=1},acodec=mpga,ab=256,channels=2}:standard{mux=ts,access=file,dst=-}" | \
  ffmpeg -re -i - -analyzeduration 2147483647 -probesize 2147483647 -y \
    -vb 3072k -s 1280x720 $VIDEO_PRESET_OPTS $HLS_OPTS out_hd_.m3u8 \
    -vb 2048k -s 800x450  $VIDEO_PRESET_OPTS $HLS_OPTS out_hi_.m3u8 \
    -vb 1024k -s 640x360  $VIDEO_PRESET_OPTS $HLS_OPTS out_med_.m3u8 \
    -vb 512k  -s 320x180  $VIDEO_PRESET_OPTS $HLS_OPTS out_medlo_.m3u8 \
    -vb 100k  -s 160x90   $VIDEO_PRESET_OPTS $HLS_OPTS out_lo_.m3u8 \
    -ab 128k              $AUDIO_PRESET_OPTS $HLS_OPTS out_audio_.m3u8