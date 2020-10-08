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
if [ -d /lib/udev/rules.d/ ]; then
  echo "Udev located in /lib"
  sudo cp lib/udev/rules.d/91-pulseaudio-gsx$type.rules /lib/udev/rules.d/
elif [ -d /etc/udev/rules.d/ ]; then
  echo "Udev located in /etc"
  sudo cp lib/udev/rules.d/91-pulseaudio-gsx$type.rules /etc/udev/rules.d/
else
  echo "Udev rules route not found, hence cancelling installation"
  echo "Expected locations: /etc/udev/rules.d/ OR /lib/udev/rules.d/"
fi

echo "Installing udev hwdb"
sudo cp etc/udev/hwdb.d/sennheiser-gsx.hwdb /etc/udev/hwdb.d/

echo "Installing pulsaudio profiles"
read -p "Should we install the channelswap-fix, see https://github.com/evilphish/sennheiser-gsx-1000/issues/9 (y for yes, n [default])? " -n 1 -r
echo 
if [[ $REPLY =~ ^[Yy]$ ]]
then
  sudo cp -r usr/share/pulseaudio/alsa-mixer/profile-sets/sennheiser-gsx-$type-channelswap.conf /usr/share/pulseaudio/alsa-mixer/profile-sets/sennheiser-gsx-$type.conf 
  echo "- installed channel-swap mix"
else
  sudo cp -r usr/share/pulseaudio/alsa-mixer/profile-sets/sennheiser-gsx-$type.conf /usr/share/pulseaudio/alsa-mixer/profile-sets/
  echo "- installed normal channel mix"
fi

if [ -d /usr/share/alsa-card-profile/mixer/profile-sets ]; then
  sudo ln -s /usr/share/pulseaudio/alsa-mixer/profile-sets/sennheiser-gsx.conf /usr/share/alsa-card-profile/mixer/profile-sets/
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
  # ignore errors if we restart too often / to fast .. we just ensure to nuke it
  pulseaudio -k > /dev/null 2>&1 || true
  pulseaudio -k > /dev/null 2>&1 || true
  pulseaudio -k > /dev/null 2>&1 || true

  echo "Ensure pulseaudio is started"
  sleep 2
  pulseaudio -D
fi

