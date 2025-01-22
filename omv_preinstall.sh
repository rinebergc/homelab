#!/bin/bash

# Pre-installation Script
# Based on https://raw.githubusercontent.com/OpenMediaVault-Plugin-Developers/installScript/master/preinstall
# See https://wiki.omv-extras.org/doku.php?id=omv7:raspberry_pi_install for more information on installing OMV

# Run this script using the following command: wget -O - https://raw.githubusercontent.com/rinebergc/homelab/refs/heads/main/omv_preinstall.sh | sudo bash

export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none

sudo apt update && sudo apt upgrade -y --no-install-recommends # Retrieve and install available package upgrades

echo " ipv6.disable=1" | sudo tee -a /boot/firmware/cmdline.txt >/dev/null # Disable IPv6

if [nmcli -t -f NAME con | grep -Fxq "Wired connection 1"]; then
  sudo nmcli con delete "Wired connection 1"
fi

if [nmcli -t -f NAME con | grep -Fxq "Wired connection 2"]; then
  sudo nmcli con modify "Wired connection 2" connection.autoconnect true
else
  echo "Wired connection 2 does not exist"
fi

sudo raspi-config nonint do_net_names 0 # Enable predictable network interface names

sudo systemctl disable hciuart # Disable the service that initalizes the BT modem, so it does not connect to the UART

echo -e "\nThe system will restart in 5 seconds.\n"
sleep 5
sudo systemctl --no-wall reboot
