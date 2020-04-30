#!/bin/bash

set -e
type=${1:-1000}

echo "Installing GSX-$type"

echo "Installing X11 config"
if [ -f /etc/debian_version ]; then
  echo "- Debian/Ubuntu base"
  sudo cp usr/share/X11/xorg.conf.d/40-sennheiser-gsx-$type.conf /usr/share/X11/xorg.conf.d/
else
  echo "- Assuming arch base"
  sudo cp usr/share/X11/xorg.conf.d/40-sennheiser-gsx-$type.conf /etc/X11/xorg.conf.d/
fi

echo "Installing udev rule"
sudo cp lib/udev/rules.d/91-pulseaudio-gsx$type.rules /lib/udev/rules.d/

echo "Installing pulsaudio profiles"
sudo cp -r usr/share/pulseaudio/alsa-mixer/profile-sets/sennheiser-gsx-$type.conf /usr/share/pulseaudio/alsa-mixer/profile-sets/

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

