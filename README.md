# sennheiser-gsx-1000
Getting the Sennheiser GSX 1000 DAC to work under Linux

![pavucontrol one](https://raw.githubusercontent.com/evilphish/sennheiser-gsx-1000/master/images/pavucontrol.png)
![pavucontrol two](https://raw.githubusercontent.com/evilphish/sennheiser-gsx-1000/master/images/pavucontrol2.png)

## Installation
Copy sennheiser-gsx-1000.conf to `/usr/share/pulseaudio/alsa-mixer/profile-sets/`

Copy 91-pulseaudio-gsx1000.rules to `/lib/udev/rules.d/`

(Or wherever your correspondig folders are located. This should be good for Debian/Mint/Ubuntu.

Reload and trigger udev (as root)
```
$> udevadm control -R
$> udevadm trigger
```

Kill pulseaudio and let the system restart it (as user)
```
$> pulseaudio -k
```
done.

## Usage

You will get two output devices, **main output** and **chat output**. The **main output** is the 7.1 audio output you want to use for anything with high quality. The **chat output** is a mono output that the GSX1000 will overlay over your 7.1 audio. You can adjust the offset volume of **chat output** vs **main output** with the small volume rocker knob on the right side of the device. This is especially handy when it comes to mumble or teamspeak. If you pipe those applications into the mono output you can freely adjust the voice overlay with the small knob and still control overall volume with the large knob. It's super effective!

## What does not work?
Controlling the software volume with the big wheel results in the volume being lowered to zero as each turning direction counts as the multimedia key Volume-Down. I disabled this by deleting the multimedia keys for volume from my cinnamon keyboard settings (Who wants to use multimedia keys if you have the GSX 1000 for that). Nonetheless, it would be great if we could teach Linux that turning the knob clockwise means Volume-Up instead of down. If anyone has any insight into this, please drop me a line or open an issue!
