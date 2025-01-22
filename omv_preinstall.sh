# Pre-installation
# https://wiki.omv-extras.org/doku.php?id=omv7:raspberry_pi_install
sudo apt update
sudo apt upgrade -y
wget -O - https://github.com/OpenMediaVault-Plugin-Developers/installScript/raw/master/preinstall | sudo bash
sudo reboot
