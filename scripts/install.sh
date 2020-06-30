#!/usr/bin/env bash

set -e

action="${1:-"install"}"

profile_files=(
  etc/udev/hwdb.d/sennheiser-gsx.hwdb
  lib/udev/rules.d/91-sennheiser-gsx-1000.rules
  lib/udev/rules.d/91-sennheiser-gsx-1200.rules
  usr/share/pulseaudio/alsa-mixer/profile-sets/sennheiser-gsx-1000-profile-set.conf
  usr/share/pulseaudio/alsa-mixer/profile-sets/sennheiser-gsx-1200-profile-set.conf
  usr/share/pulseaudio/alsa-mixer/paths/sennheiser-gsx-1000-output-comm.conf
  usr/share/pulseaudio/alsa-mixer/paths/sennheiser-gsx-1000-output-main.conf
)

install() {
  echo "Installing GSX 1000 / 1200 Pro"
  echo -n "Installing files... "

  for file in "${profile_files[@]}"; do
    f_orig=$(readlink -f "src/${file}")
    f_dest="/${file}"
    sudo cp "${f_orig}" "${f_dest}"
  done

  echo "OK"
}

uninstall() {
  echo "Uninstalling GSX 1000 / 1200 Pro"
  echo -n "removing files... "
  for file in "${profile_files[@]}"; do
    f_dest="/${file}"
    sudo rm "${f_dest}"
  done
  echo "OK"
}

"${action}"
./scripts/restart-devices.sh
