# sennheiser-gsx-1000 / 1200 Pro
Getting the Sennheiser GSX 1000 / 1200 Pro DAC to work under Linux

![pavucontrol one](https://raw.githubusercontent.com/evilphish/sennheiser-gsx-1000/master/images/pavucontrol.png)
![pavucontrol two](https://raw.githubusercontent.com/evilphish/sennheiser-gsx-1000/master/images/pavucontrol2.png)

## Installation
Copy sennheiser-gsx-1000.conf or sennheiser-gsx-1200.conf to `/usr/share/pulseaudio/alsa-mixer/profile-sets/`

Copy 91-pulseaudio-gsx1000.rules or 91-pulseaudio-gsx-1200.rules to `/lib/udev/rules.d/`

Copy 40-sennheiser-gsx-1000.conf or 40-sennheiser-gsx-1200.conf to `/etc/X11/xorg.conf.d/` to disable it as an input device. The reason you would want to do this is because the big wheel always maps to volume down, so turning it will always lower your volume to zero. This is a temporary fix which just disables it as an input device so that turning the wheel will not modify the internal volume specifier, without affecting your normal media keys.

(Or wherever your correspondig folders are located. This should be good for Debian/Mint/Ubuntu/Arch Linux.

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

You will get two output devices, **main output** and **chat output**. The **main output** is the 7.1 audio output you want to use for anything with high quality. The **chat output** is a mono output that the GSX1000 / GSX1200 Pro will overlay over your 7.1 audio. You can adjust the offset volume of **chat output** vs **main output** with the small volume rocker knob on the right side of the device. This is especially handy when it comes to mumble or teamspeak. If you pipe those applications into the mono output you can freely adjust the voice overlay with the small knob and still control overall volume with the large knob. It's super effective!

## What does not work?
Controlling the software volume with the big wheel results in the volume being lowered to zero as each turning direction counts as the multimedia key Volume-Down. I disabled this by deleting the multimedia keys for volume from my cinnamon keyboard settings (Who wants to use multimedia keys if you have the GSX 1000 for that). Nonetheless, it would be great if we could teach Linux that turning the knob clockwise means Volume-Up instead of down. If anyone has any insight into this, please drop me a line or open an issue!

## Arch Linux users
Just reboot after install
