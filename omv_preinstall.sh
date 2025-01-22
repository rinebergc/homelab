#!/bin/bash

# Pre-installation Script
# Based on https://raw.githubusercontent.com/OpenMediaVault-Plugin-Developers/installScript/master/preinstall
# See https://wiki.omv-extras.org/doku.php?id=omv7:raspberry_pi_install for more information on installing OMV

# Run this script using the following command: wget -O - https://raw.githubusercontent.com/rinebergc/homelab/refs/heads/main/omv_preinstall.sh | sudo bash

export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none

sudo apt update -q && sudo apt upgrade -q=2 --no-install-recommends # Retrieve and install available package upgrades

sudo raspi-config nonint do_boot_splash 1 # Disable the splash screen displayed at boot time
sudo raspi-config nonint do_leds 1 # Keep the power LED lit at all times, do not flash for disk activity
sudo raspi-config nonint do_net_names 0 # Enable predictable network interface names

echo "dtoverlay=disable-bt-pi5" | sudo tee -a /boot/firmware/config.txt  # Disable Bluetooth
echo "dtoverlay=disable-wifi-pi5" | sudo tee -a /boot/firmware/config.txt  # Disable Wi-Fi

INTERFACE="enx6c1ff7171aa4"
DRIVER="r8152"
MAC="6c:1f:f7:17:1a:a4"

echo -e "\nInterface Name: ${INTERFACE}"
echo "Driver: ${DRIVER}"
echo -e "MAC Address: ${MAC}\n"

echo ""
echo -e "[Match]\nMACAddress=${MAC}\nDriver=${DRIVER}\n[Link]\nName=${INTERFACE}" > /etc/systemd/network/10-persistent-eth0.link

echo "The system will restart immediately."
sudo systemctl --no-wall reboot
