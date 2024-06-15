# TeslaPiWifi
Tesla Sentinel Storage over Wifi

Ever wanted a simple way to download your video from your Tesla ?
Here is a cool solution ; a wifi SD Card powered by a small RaspberryPi Zero W !

Plug the usb cable on your Tesla. Your car will reconize it as a classic USB drive to store its camera files.
On the other side, connect the Pi to your wifi network, and use WinsSCP (https://winscp.net/) to securely transfert files.

Preparing the Raspberry Pi

The first step in making a Raspberry Pi based USB stick is to install the slimmest operating system that you can get away with. We need it “headless”, that is to operate without a graphical interface, keyboard or mouse, and we don’t need all the bundled software, just enough.

Use Raspberry Pi Imager (https://www.raspberrypi.com/software/)  to install Raspberry Pi OS to a microSD card, ready to use with your Raspberry Pi.
Select Light OS  under “other”

Configure your Raspberry Pi SD card operating system and wifi connection details
Choose an SD card, whatever size will be large enough to have a couple of gigs plus whatever capacity you want to make our USB stick appear to be.

It took a 128Gb card and created a 64 Gb "virtual" usb drive on it.

After the SD card is written, you can remove it from your card reader and insert it into the Pi for first boot.

If you forget to Configure Wifi, don't panic, you can do it now : 

Put your sdcard in your computer. On the boot partition,  create a wpa_supplicant.conf file with those data : 

country=FR
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
  scan_ssid=1
  ssid="Mon_Réseau_Wifi"
  psk="le_mot_de_passe_de_mon_réseau"
  key_mgmt=WPA-PSK
}

Restart your pi with the fresh new configuration et Voila !  Wifi should ping in a couple of minutes.
If you need more details to configure your file, have a look at https://linux.die.net/man/5/wpa_supplicant.conf

Now you can log on your pi Zero. 
Downloade this script : 
** wget https://raw.githubusercontent.com/omiq/piusb/main/setup.sh -O setup.sh
** chmod +x setup.sh

Before running it, please adapt it to your configuration (mainly the size of your card) :
** nano setup.sh

then Go !

# sudo ./setup.sh

After the reboot, you should see a news sdcard on your computer.
Just plug it now on your Tesla instead of your current usb drive.

Try to store some video the Tesla, then connect to the Pi with WinSCP.

To refresh the content of the 


Based on several original source code like those ones : 
https://www.makerhacks.com/piusb-wifi-memory-stick/
https://magpi.raspberrypi.com/articles/pi-zero-w-smart-usb-flash-drive
