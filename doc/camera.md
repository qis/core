# Camera

```sh
# List devices.
v4l2-ctl --list-devices

# List internal webcam formats.
v4l2-ctl -d /dev/video0 --list-formats-ext

# ioctl: VIDIOC_ENUM_FMT
#         Type: Video Capture
#         [0]: 'MJPG' (Motion-JPEG, compressed)
#                 Size: Discrete 1920x1080
#                         Interval: Discrete 0.033s (30.000 fps)

# List external webcam formats.
v4l2-ctl -d /dev/video4 --list-formats-ext

# ioctl: VIDIOC_ENUM_FMT
#         Type: Video Capture
#         [1]: 'MJPG' (Motion-JPEG, compressed)
#                 Size: Discrete 1280x720
#                         Interval: Discrete 0.017s (60.000 fps)
#                 Size: Discrete 1920x1080
#                         Interval: Discrete 0.033s (30.000 fps)

# Display internal webcam video.
mpv --demuxer-lavf-o=input_format=mjpeg,video_size=1920x1080,framerate=30 \
  av://v4l2:/dev/video0 --profile=low-latency --untimed

# Display external webcam video (best resolution).
mpv --demuxer-lavf-o=input_format=mjpeg,video_size=1920x1080,framerate=30 \
  av://v4l2:/dev/video4 --profile=low-latency --untimed

# Display external webcam video (best frame rate).
mpv --demuxer-lavf-o=input_format=mjpeg,video_size=1280x720,framerate=60 \
  av://v4l2:/dev/video4 --profile=low-latency --untimed
```
