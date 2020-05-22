#!/bin/bash

set -e
type=${1:-1000}

echo "Installing GSX-$type"

echo "Installing X11 config"
if [ ! -d /etc/X11/xorg.conf.d ]; then
  sudo mkdir -p /etc/X11/xorg.conf.d;
fi
  sudo cp usr/share/X11/xorg.conf.d/40-sennheiser-gsx-$type.conf /etc/X11/xorg.conf.d/

echo "Installing udev rule"
sudo cp lib/udev/rules.d/91-pulseaudio-gsx$type.rules /lib/udev/rules.d/

echo "Installing udev hwdb"
sudo cp etc/udev/hwdb.d/sennheiser-gsx.hwdb /etc/udev/hwdb.d/

echo "Installing pulsaudio profiles"
read -p "Should we install the channelswap-fix, see https://github.com/evilphish/sennheiser-gsx-1000/issues/9 (y for yes, n [default])? " -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
  sudo cp -r usr/share/pulseaudio/alsa-mixer/profile-sets/sennheiser-gsx-$type-channelswap.conf /usr/share/pulseaudio/alsa-mixer/profile-sets/
  echo "- installed channel-swap mix"
else
  sudo cp -r usr/share/pulseaudio/alsa-mixer/profile-sets/sennheiser-gsx-$type.conf /usr/share/pulseaudio/alsa-mixer/profile-sets/
  echo "- installed normal channel mix"
fi

echo "Reloading udev rules"
sudo systemd-hwdb update
sudo udevadm control -R
sudo udevadm trigger

read -p "SKIP pulseaudio be restart () (y for yes, n [default])? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "Skipped pulseaudio restart"
else
  echo "Restarting pulse audio"
  systemctl --user restart pulseaudio.service
fi

