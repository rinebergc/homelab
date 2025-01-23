#!/bin/bash

# Pre-installation Script
# Inspired by https://raw.githubusercontent.com/OpenMediaVault-Plugin-Developers/installScript/master/preinstall
# See https://wiki.omv-extras.org/doku.php?id=omv7:raspberry_pi_install for more information on installing OMV

# Run this script using the following command: wget -O - https://raw.githubusercontent.com/rinebergc/homelab/refs/heads/main/omv_preinstall.sh | bash

export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none

echo 'Checking for available package upgrades...'
apt update && apt upgrade -y --no-install-recommends # Retrieve and install available package upgrades

if ! grep -Fq 'ipv6.disable=1' /boot/firmware/cmdline.txt; then
  echo 'Appending ipv6.disable=1 to cmdline.txt...'
  echo ' ipv6.disable=1' | tee -a /boot/firmware/cmdline.txt # Disable IPv6
fi

nmcli -t -f GENERAL.DEVICE,GENERAL.HWADDR,GENERAL.CONNECTION device show
echo 'Configuring LAN...'
ACTIVE_CONNECTION="$(nmcli -t -f NAME con show --active)"
MAC_ADDRESS="$(nmcli -t -g GENERAL.HWADDR,GENERAL.CONNECTION device show | grep -B 1 "${ACTIVE_CONNECTION}" | sed -n '1s/\\//g;1s/://g;1p' | tr 'A-Z' 'a-z')"
if [[ "$(nmcli -t -f DEVICE con show --active)" != "enx${MAC_ADDRESS}" ]]; then
  echo 'Enabling predictable network interface names...'
  raspi-config nonint do_net_names 0 # Enable predictable network interface names
fi
nmcli con modify "${ACTIVE_CONNECTION}" connection.autoconnect true
nmcli con modify "${ACTIVE_CONNECTION}" connection.autoconnect-priority 999
nmcli con modify "${ACTIVE_CONNECTION}" connection.autoconnect-retries 0

if [[ "$(systemctl is-enabled hciuart)" == 'Enabled' ]]; then
  echo 'Disabling hciuart...'
  if [[ "$(systemctl is-active hciuart)" == 'Active' ]]; then
    systemctl stop hciuart
  fi
  systemctl disable hciuart # Disable the service for initalizing/configuring Bluetooth modems
fi

if ! dpkg-query -W rockpi-penta | grep -Fq 'rockpi-penta'; then
  echo 'Installing the Penta TopHAT drivers...'
  wget https://github.com/radxa/rockpi-penta/releases/download/v0.2.2/rockpi-penta-0.2.2.deb # Download the Penta TopHAT drivers
  apt install -y ./rockpi-penta-0.2.2.deb
  rm rockpi-penta-0.2.2.deb
fi

echo -e '\nThe system will restart in 5 seconds.\n'
sleep 5
systemctl --no-wall reboot
