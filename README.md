# sennheiser-gsx-1000 / 1200 Pro
Getting the Sennheiser GSX 1000 / 1200 Pro DAC to work under Linux

![pavucontrol one](https://raw.githubusercontent.com/evilphish/sennheiser-gsx-1000/master/images/pavucontrol.png)
![pavucontrol two](https://raw.githubusercontent.com/evilphish/sennheiser-gsx-1000/master/images/pavucontrol2.png)

## Installation

Just run

```
# gsh 1000
./install.sh

#gsx1200
./install.sh 1200
```

## Deinstallation

```
# gsh 1000
./uninstall.sh

#gsx1200
./uninstall.sh 1200
```

## Manual Installation
Copy sennheiser-gsx-1000.conf or sennheiser-gsx-1200.conf to `/usr/share/pulseaudio/alsa-mixer/profile-sets/`

Copy 91-pulseaudio-gsx1000.rules or 91-pulseaudio-gsx-1200.rules to `/lib/udev/rules.d/`

Copy 40-sennheiser-gsx-1000.conf or 40-sennheiser-gsx-1200.conf to `/usr/share/X11/xorg.conf.d/` (Debian-based) or `/etc/X11/xorg.conf.d`(Arch) to disable it as an input device. The reason you would want to do this is because the big wheel always maps to volume down, so turning it will always lower your volume to zero. This is a temporary fix which just disables it as an input device so that turning the wheel will not modify the internal volume specifier, without affecting your normal media keys. On other distributions the folders might be in different locations. Consult your distribution's documentation.

Reload and trigger udev (as root)
```
$> udevadm control -R
$> udevadm trigger
```

Kill pulseaudio and let the system restart it (as user)
```
$> pulseaudio -k
```

Next you want to list your available sinks
```
$> pacmd list-sinks | grep -e 'index:' -e device.string -e 'name: '
```
and you should get something like this
```
    index: 0
	name: <alsa_output.usb-Sennheiser_GSX_1000_Main_Audio_5698800398027817-00.analog-output-surround71>
		device.string = "hw:CARD=GSX1000,DEV=1"
*   index: 1
	name: <alsa_output.usb-Sennheiser_GSX_1000_Main_Audio_5698800398027817-00.analog-output-chat>
		device.string = "hw:CARD=GSX1000,DEV=0"
    index: 2
	name: <alsa_output.pci-0000_09_00.1.hdmi-stereo-extra2>
		device.string = "hdmi:0,2"
```
Notice, how the asterisk marking the default output sink is in front of the analog-output-chat? We want the default sink to be the 7.1 audio so copy the name from the surround71 output (without the <>), edit `/etc/pulse/default.pa` and add the following line at the end
```
set-default-sink <your sink name>
```
on my system with the example above this would be
```
set-default-sink alsa_output.usb-Sennheiser_GSX_1000_Main_Audio_5698800398027817-00.analog-output-surround71
```

Kill pulseaudio again and let the system restart it (as user)
```
$> pulseaudio -k
```

done.

## Usage

You will get two output devices, **main output** and **chat output**. The **main output** is the 7.1 audio output you want to use for anything with high quality. The **chat output** is a mono output that the GSX1000 / GSX1200 Pro will overlay over your 7.1 audio. You can adjust the offset volume of **chat output** vs **main output** with the small volume rocker knob on the right side of the device. This is especially handy when it comes to mumble or teamspeak. If you pipe those applications into the mono output you can freely adjust the voice overlay with the small knob and still control overall volume with the large knob. It's super effective!

## What does not work?
Controlling the software volume with the big wheel results in the volume being lowered to zero as each turning direction counts as the multimedia key Volume-Down. The xorg.conf.d files mentioned above disable key inputs for the GSX devices to work around this issue. You could also delete or disable the multimedia volume keys in your keyboard settings (Who wants to use multimedia keys if you have the GSX 1000 for that). Nonetheless, it would be great if we could teach Linux that turning the knob clockwise means Volume-Up instead of down. If anyone has any insight into this, please drop me a line or open an issue! The internal volume adjustment of the GSX works though! So you can change the volume, just not in your system but in your deveice. 

## Arch Linux users
Just reboot after install
