#!/bin/bash

set -e
type=${1:-1000}

echo "Uninstalling GSX-$type"

sudo rm -f /usr/share/X11/xorg.conf.d/40-sensheiser-gsx-$type.conf
sudo rm -f /etc/X11/xorg.conf.d/40-sensheiser-gsx-$type.conf
sudo rm -f /lib/udev/rules.d/91-pulseaudio-gsx$type.rules 
sudo rm -f /etc/udev/rules.d/91-pulseaudio-gsx$type.rules 
sudo rm -f /usr/share/pulseaudio/alsa-mixer/profile-sets/sennheiser-gsx-$type.conf
sudo rm -f /usr/share/alsa-card-profile/mixer/profile-sets/sennheiser-gsx.conf

echo "Reloading udev rules"
sudo udevadm control -R
sudo udevadm trigger

read -p "Should pulseaudio be restarted (y for yes)? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo "Restart pulse audio"
  pulseaudio -k > /dev/null 2>&1 || true
  pulseaudio -k > /dev/null 2>&1 || true
  pulseaudio -k > /dev/null 2>&1 || true

  echo "Ensure pulseaudio is started"
  sleep 2
  pulseaudio -D
else
  echo "Skipped pulseaudio restart"
fi

