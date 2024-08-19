# **! This repository is discontinued due to having no relevance as of 2024 !**
- This script likely will not work on modern mainstream distros due to them slowly transitioning to PipeWire and Wayland.
- There is no point in that script as offcial Discord client is now way more capable on Linux comparing to how it was before, and having alternatives like Vesktop that provides lots of additional features.
- If neither of the 2 options above work for you, you can also use web version via Chromium, though I've heard that the quality is not great.

# hikkaAVStream
Allows you to bypass discords' limitations on streaming with linux. With hikkaAVStream you can stream one of your monitors if you have dual screen setup, while also streaming audio.

Dependencies:
-
- xrandr
- ffmpeg
- v4l2loopback
- pulseaudio

Note to ubuntu users:
-
I wasn't able to use v4l2loopback provided by ubuntu's repository. I don't exactly know why, but with v4l2loopback installed with apt, ffmpeg just spits out error. I provided kernel module for Linux 5.0.0-25, but if you'll ever need to use this utility on newer version of linux, please compile v4l2loopback yourself. 

Instructions:
-
- Install dependencies
- Clone repo
- Follow comments in 'havs.sh'
- Run `chmod +x havs.sh`
- Run `./havs.sh`
- Follow prompt
- Switch discord webcam to dummy device (Must be running)
- Switch discord microphone to "Input" device monitor. (This could be done using pavucontrol)
- Switch output device in your aplication to "OutputInputSpeakers"

```
./havs.sh - Monitor to Camera

./havs.sh [option] [value]

options:
-h, --help                show help
-f, --framerate=FPS       set framerate
-d, --device-number=NUM   set device number
-m, --monitor-number=NUM  set monitor number
```

```
Monitors: 2
 0: +*DP-0 1920/531x1080/299+0+0  DP-0
 1: +HDMI-0 1366/410x768/230+1920+0  HDMI-0
Which monitor: 0
CTRL + C to stop
```
TODO
-
- Better way of setting up audio devices
- Better way of setting up resolution

Mentions
- [Mon2Cam](https://github.com/ShayBox/Mon2Cam) for foundation and video.
- [pulseaudio-config](https://github.com/toadjaune/pulseaudio-config) for audio.
- [v4l2loopback](https://github.com/umlaeute/v4l2loopback) for making this work. 
