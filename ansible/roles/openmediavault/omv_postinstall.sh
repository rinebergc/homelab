# Post-installation

# https://wiki.omv-extras.org/doku.php?id=omv7:new_user_guide#server_notifications
# https://wiki.omv-extras.org/doku.php?id=omv7:new_user_guide#enable_smart
# https://wiki.omv-extras.org/doku.php?id=omv7:new_user_guide#drive_self-tests

# Install the zfs plugin (UI)

# https://forum.openmediavault.org/index.php?thread/46136-raid10-via-zfs-plugin/
sudo mkdir /mnt/pools
sudo zpool create -m /mnt/pools/pool1 pool1 mirror ata-CT1000MX500SSD1_2052E4E1523C ata-CT1000MX500SSD1_2052E4E188B5 mirror ata-CT1000MX500SSD1_2052E4E188C0 ata-CT1000MX500SSD1_2052E4E188E1

# https://wiki.omv-extras.org/doku.php?id=misc_docs:auto_zfs_snapshots
wget https://github.com/zfsonlinux/zfs-auto-snapshot/archive/master.zip
unzip master.zip
cd zfs-auto-snapshot-master
sudo make install

sudo zfs set com.sun:auto-snapshot=true pool1
sudo zfs set com.sun:auto-snapshot:frequent=false pool1
sudo zfs set com.sun:auto-snapshot:hourly=false pool1
sudo zfs set com.sun:auto-snapshot:daily=false pool1
sudo zfs set com.sun:auto-snapshot:weekly=true pool1
sudo zfs set com.sun:auto-snapshot:monthly=false pool1

create scheduled task "zpool trim <poolname>" run monthly

sudo apt autoremove

https://www.jeffgeerling.com/blog/2023/reducing-raspberry-pi-5s-power-consumption-140x
# Lower power consumption when pi is off
POWER_OFF_ON_HALT=1
WAKE_ON_GPIO=0
