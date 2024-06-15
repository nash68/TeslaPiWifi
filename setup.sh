#!/bin/bash

# Download latest from github: 
# wget https://raw.githubusercontent.com/nash68/TeslaPiWifi/main/setup.sh -O setup.sh
# chmod +x setup.sh
# sudo ./setup.sh

if [[ $EUID -ne 0 ]]; then
    echo ""
    echo "_______________________________"
    echo "Please use Sudo or run as root."
    echo "==============================="
    echo ""
    echo ""
    exit
fi

echo ""
echo ""
echo "Set local time zone"
echo "Configure USB on Pi"
echo "Name your pi as teslapiwifi
echo "=========================================================="
echo ""
echo ""
#Put your local timezone
timedatectl set-timezone "Europe/Paris"

#Be carrefull, in june 2024, the config file is under a firmware subdirectory
echo "dtoverlay=dwc2" >> /boot/firmware/config.txt
echo "dwc2" >> /etc/modules

#Name your pi
sed -i "s/$(hostname)/teslapiwifi/" /etc/hosts
echo "teslapiwifi" > /etc/hostname

echo ""
echo ""
echo "Creating the USB stick storage. This might take some time!"
echo "=========================================================="
echo ""
echo ""
# Set the size of your virtual usb stick storage as appropriate (be carrefull, this is very very long on large files
# you can monitor this task by openning a second session and lauchn ; 
# ls -lS --block-size=K /piusb.bin 

# 1GB = 1024
# 16GB = 16384
# 64GB = 65536
dd bs=1M if=/dev/zero of=/piusb.bin count=1024
mkdosfs /piusb.bin -F 32 --mbr=yes -n PIUSB
echo ""
echo ""
echo "USB storage created. Continuing configuration ..."
echo "=========================================================="
echo ""
echo ""

# Create the mount
echo ""
echo "Mounting the storage"
echo "=========================================================="
echo ""
mkdir /mnt/usbstick
chmod +w /mnt/usbstick
echo "/piusb.bin /mnt/usbstick vfat rw,users,user,exec,umask=000 0 0" >> /etc/fstab
mount -a
sudo modprobe g_mass_storage file=/piusb.bin stall=0 ro=0

# Dependencies
echo ""
echo "Installing dependencies"
echo "=========================================================="
echo ""

# Refesh, remount script
echo ""
echo "Creating refresh script"
echo "=========================================================="
echo ""
echo "sync" >> refreshpiusb.sh
echo "modprobe -r g_mass_storage" >> refreshpiusb.sh
echo "umount /mnt/usbstick " >> refreshpiusb.sh
echo "mount -a will remount " >> refreshpiusb.sh
echo "modprobe g_mass_storage file=/piusb.bin stall=0 ro=0" >> refreshpiusb.sh
echo "sync" >> refreshpiusb.sh
sudo chmod +x refreshpiusb.sh


# Run on boot
sed -i '$d' /etc/rc.local
echo "sudo /refreshpiusb.sh" >> /etc/rc.local
echo "" >> /etc/rc.local

# Fin?
echo ""

echo "=========================================================="
echo "Done! You can reboot now by typing : "
echo "sudo reboot now"
echo ""
reboot now
