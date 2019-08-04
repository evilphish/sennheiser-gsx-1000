sudo cp etc/X11/xorg.conf.d/40-sennheiser-gsx-1000.conf /etc/X11/xorg.conf.d
sudo cp lib/udev/rules.d/91-pulseaudio-gsx1000.rules /lib/udev/rules.d/
sudo cp -r usr/share/pulseaudio/alsa-mixer/profile-sets/sennheiser-gsx-1000.conf /usr/share/pulseaudio/alsa-mixer/profile-sets/
