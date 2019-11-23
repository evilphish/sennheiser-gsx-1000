sudo cp etc/X11/xorg.conf.d/40-sennheiser-gsx-1200.conf /etc/X11/xorg.conf.d
sudo cp lib/udev/rules.d/91-pulseaudio-gsx1200.rules /lib/udev/rules.d/
sudo cp -r usr/share/pulseaudio/alsa-mixer/profile-sets/sennheiser-gsx-1200.conf /usr/share/pulseaudio/alsa-mixer/profile-sets/
sudo udevadm control -R
sudo udevadm trigger

pulseaudio -k
pulseaudio -k
pulseaudio -k
sleep 2
pulseaudio -k
pulseaudio -D
