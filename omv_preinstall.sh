#!/bin/bash

# Pre-installation Script
# Inspired by https://raw.githubusercontent.com/OpenMediaVault-Plugin-Developers/installScript/master/preinstall
# See https://wiki.omv-extras.org/doku.php?id=omv7:raspberry_pi_install for more information on installing OMV

# Run this script using the following command: wget -O - https://raw.githubusercontent.com/rinebergc/homelab/refs/heads/main/omv_preinstall.sh | sudo bash

export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none

echo "Checking for available package upgrades..."
sudo apt update -q=2 && sudo apt upgrade -q=2 --no-install-recommends # Retrieve and install available package upgrades

if ! grep -Fq "ipv6.disable=1"; then
  echo "Appending ipv6.disable=1 to cmdline.txt..."
  echo " ipv6.disable=1" | sudo tee -a /boot/firmware/cmdline.txt >/dev/null # Disable IPv6
fi

if nmcli -t -f NAME con | grep -Fq "Wired connection 2"; then
  echo "Configuring LAN..."
  if ! nmcli -t -f NAME con | grep -Fq "enx6c1ff7171aa4"; then
    sudo raspi-config nonint do_net_names 0 # Enable predictable network interface names
  fi
  sudo nmcli con modify Wired\ connection\ 2 connection.autoconnect true
  sudo nmcli con modify Wired\ connection\ 2 connection.autoconnect-priority 999
  sudo nmcli con modify Wired\ connection\ 2 connection.autoconnect-retries 0
fi

if sudo systemctl is-enabled hciuart; then
  echo "Disabling hciuart..."
  if sudo systemctl is-active hciuart; then
    sudo systemctl stop hciuart >/dev/null
  fi
  sudo systemctl disable hciuart # Disable the service for initalizing/configuring Bluetooth modems
fi

if ! dpkg-query -W rockpi-penta | grep -Fq "rockpi-penta"; then
  echo "Installing the Penta TopHAT drivers..."
  wget https://github.com/radxa/rockpi-penta/releases/download/v0.2.2/rockpi-penta-0.2.2.deb # Download the Penta TopHAT drivers
  sudo apt install -y ./rockpi-penta-0.2.2.deb
fi

echo -e "\nThe system will restart in 5 seconds.\n"
sleep 5
sudo systemctl --no-wall reboot
