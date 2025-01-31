#!/bin/bash

# Pre-installation Script
# Inspired by https://raw.githubusercontent.com/OpenMediaVault-Plugin-Developers/installScript/master/preinstall
# See https://wiki.omv-extras.org/doku.php?id=omv7:raspberry_pi_install for more information on installing OMV

# Run this script using the following command: wget -O - https://raw.githubusercontent.com/rinebergc/homelab/refs/heads/main/raspberry_pi/omv_preinstall.sh | sudo bash

export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none

echo "Configuring LAN..."
# Get the name of the active connection
ACTIVE_CONNECTION="$(nmcli -t -f NAME con show --active | grep -v "lo")"
# Get the name of the active interface
INTERFACE="enx$(nmcli -t -g GENERAL.HWADDR,GENERAL.CONNECTION device show | grep -B 1 "${ACTIVE_CONNECTION}" | sed -n '1s/\\//g;1s/://g;1p' | tr 'A-Z' 'a-z')"
# Configure auto-connect
nmcli con modify "${ACTIVE_CONNECTION}" connection.autoconnect true connection.autoconnect-priority 999 connection.autoconnect-retries 0
# Enable predictable network interface names
if [[ "$(nmcli -t -f DEVICE con show --active)" != "${INTERFACE}" ]]; then
  raspi-config nonint do_net_names 0
fi
# Disable IPv6
if [[ "$(cat /proc/sys/net/ipv6/conf/${INTERFACE}/disable_ipv6 &>/dev/null)" != "1" ]]; then
  nmcli con modify "${ACTIVE_CONNECTION}" ipv6.method "disabled"
fi

if [[ "$(systemctl is-enabled hciuart)" == "Enabled" ]]; then
  echo "Disabling hciuart..."
  if [[ "$(systemctl is-active hciuart)" == "Active" ]]; then
    # Stop the service if it is currently runnning
    systemctl stop hciuart
  fi
  # Disable hciuart (service for initalizing/configuring Bluetooth modems)
  systemctl disable hciuart
fi
