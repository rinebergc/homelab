#!/bin/bash

# Pre-installation Script
# Based on https://raw.githubusercontent.com/OpenMediaVault-Plugin-Developers/installScript/master/preinstall
# See https://wiki.omv-extras.org/doku.php?id=omv7:raspberry_pi_install for more information on installing OMV

# Run this script using the following command: wget -O - https://raw.githubusercontent.com/rinebergc/homelab/main/omv_preinstall.sh | sudo bash

export DEBIAN_FRONTEND=noninteractive
export APT_LISTCHANGES_FRONTEND=none

sudo apt update && sudo apt upgrade -y --no-install-recommends
sudo raspi-config nonint do_net_names 0

INTERFACE="enx6c1ff7171aa4"
MAC="6c:1f:f7:17:1a:a4"

echo "Interface Name: ${INTERFACE}"
echo "MAC Address: ${MAC}"
echo -e "[Match]\nMACAddress=${MAC}\n[Link]\nName=${INTERFACE}" > /etc/systemd/network/10-persistent-eth0.link

sudo shutdown -r now
