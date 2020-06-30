#!/usr/bin/env bash

set -e

# --
echo -n "Reloading udev rules..."
sudo systemd-hwdb update
sudo udevadm control -R
sudo udevadm trigger

echo "OK"

# --
echo -n "Restarting pulseaudio... "
pulseaudio -k > /dev/null 2>&1 || true
pulseaudio -k > /dev/null 2>&1 || true
pulseaudio -k > /dev/null 2>&1 || true

sleep 1
pulseaudio --start

echo "OK"
