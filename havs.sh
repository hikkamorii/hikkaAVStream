#!/bin/bash
#
# hikkaAVStream is a fork of 
#
# Variables
RESOLUTION=1280x720
FPS=25
DEVICE=10
# Path to v4l2loopback kernel module
VL2LKO="v4l2loopback.ko"
#
# You need to provide your variables for your audio devices.
#
# Run "pacmd list-sources" to get microphone device name
# Run "pacmd list-sinks" to get speaker device name
# Read README.MD for more info.
#
MICROPHONE="alsa_input.usb-GeneralPlus_USB_Audio_Device-00.analog-mono"
SPEAKERS="alsa_output.pci-0000_00_1b.0.analog-stereo"
# End Default Variables

# Options
while [ ! $# -eq 0 ]
do
	case "$1" in
		-h | --help)
			echo "$0 - Monitor to Camera"
			echo ""
			echo "$0 [option] [value]"
			echo ""
			echo "options:"
			echo "-h, --help                show help"
			echo "-f, --framerate=FPS       set framerate"
			echo "-d, --device-number=NUM   set device number"
			echo "-m, --monitor-number=NUM  set monitor number"
			echo "-vf, --vertical-flip      vertically flip the monitor capture"
			echo "-hf, --horizontal-flip    horizontally flip the monitor capture"
			exit
		;;
		-f | --framerate)
			FPS=$2
		;;
		-d | --device-number)
			DEVICE_NUMBER=$2
		;;
		-m | --monitor-number)
			MONITOR_NUMBER=$2
		;;
		-vf | --vertical-flip)
			VFLIP="-vf vflip"
		;;
		-hf | --horizontal-flip)
			HFLIP="-vf hflip"
		;;
	esac
	shift
done
# End Options

# Dependency checking
XRANDR=$(command -v xrandr)
if ! [ -x $XRANDR ]
then
	echo "Error: xrandr is not installed."
	exit 1
fi

FFMPEG=$(command -v ffmpeg)
if ! [ -x $FFMPEG ]
then
	echo "Error: ffmpeg is not installed."
	exit 1
fi
# End Dependency checking

# Option checking
if [ -z $MONITOR_NUMBER ]
then
	$XRANDR --listactivemonitors
	read -p "Which monitor: " MONITOR_NUMBER
fi
# End Option checking

# Monitor information
MONITOR_INFO=`xrandr --listactivemonitors | grep "$MONITOR_NUMBER:" | cut -f4 -d' '`
MONITOR_HEIGHT=`echo $MONITOR_INFO | cut -f2 -d'/' | cut -f2 -d'x'`
MONITOR_WIDTH=`echo $MONITOR_INFO | cut -f1 -d'/'`
MONITOR_X=`echo $MONITOR_INFO | cut -f2 -d'+'`
MONITOR_Y=`echo $MONITOR_INFO | cut -f3 -d'+'`
# End Monitor information

# Start hikkaAVS
if ! $(sudo modprobe -r v4l2loopback &> /dev/null)
then
    echo "Turn off any sources using Mon2Cam before starting script"
    exit 1
fi

echo "CTRL + C to stop"
echo "Your screen will look mirrored for you, not others"
sudo modprobe -r v4l2loopback
sudo depmod -a
sudo modprobe videodev

# Uncomment this if you want to use kernel module from package manager:
#sudo modprobe v4l2loopback devices=1 video_nr=$DEVICE exclusive_caps=1

# Uncomment this if you're running Ubuntu on kernel 5.0.0-25:
sudo insmod $VL2LKO devices=1 video_nr=$DEVICE exclusive_caps=1
# Make sure to compile module for your kernel if you have to.

# Create sink devices to for audio.
pactl load-module module-null-sink sink_name=virtual1 sink_properties=device.description="OutputInputSpeakers"
pactl load-module module-null-sink sink_name=virtual2 sink_properties=device.description="Input"
pactl load-module module-loopback source=virtual1.monitor sink=$SPEAKERS
pactl load-module module-loopback source=virtual1.monitor sink=virtual2
pactl load-module module-loopback source=$MICROPHONE sink=virtual2
$FFMPEG -f x11grab -r 30 -s $RESOLUTION -i "$DISPLAY"+"$MONITOR_X","$MONITOR_Y" -vcodec rawvideo  -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video$DEVICE
pacmd unload-module module-loopback
pacmd unload-module module-null-sink
# End hikkaAVStream
