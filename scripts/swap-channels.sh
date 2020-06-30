#!/usr/bin/env bash

set -e

default_channels="front-left,front-right,rear-left,rear-right,front-center,lfe,side-left,side-right"
swapped_channels="front-left,front-right,front-center,lfe,rear-left,rear-right,side-left,side-right"

setup=${1:-"default"}

setup_channels() {
  local profile_files=(
    /usr/share/pulseaudio/alsa-mixer/profile-sets/sennheiser-gsx-1000-profile-set.conf
    /usr/share/pulseaudio/alsa-mixer/profile-sets/sennheiser-gsx-1200-profile-set.conf
  )
  local channels="${1}"

  for file in "${profile_files[@]}"; do
    sudo sed -i "7s/.*/channel-map = ${channels}/" "$(readlink -f "${file}")"
  done
}

case $setup in
"default")
  echo -n "Installing ${setup} channels config..."
  setup_channels "${default_channels}"
  echo "OK"
  ./scripts/restart-devices.sh
  ;;
"swapped")
  echo -n "Installing ${setup} channels config..."
  setup_channels "${swapped_channels}"
  echo "OK"
  ./scripts/restart-devices.sh
  ;;
*)
  echo "swap-channels [default|swapped]"
  exit 1
  ;;
esac
