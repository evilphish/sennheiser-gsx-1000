# sennheiser-gsx-1000
Getting the Sennheiser GSX 1000 DAC to work under Linux

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
