#!/bin/bash
#Jetson stuff

#edit sudoers file with : visudo
#    myuser ALL=(ALL) NOPASSWD:ALL

USER=user

sudo bash -c 'echo "$USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/99_sudo_include_file'    

#Check that your sudoers include file passed the visudo syntax checks:
sudo visudo -cf /etc/sudoers.d/99_sudo_include_file

#now can use sudo
    
sudo apt install nano haveged curl apt-transport-https gparted ufw gufw

#sudo nano /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
#edit section below so you can update to 32.5.1 jetpack
#t194 for Jetson AGX Xavier series or Jetson Xavier NX
#deb https://repo.download.nvidia.com/jetson/common r32.5 main
#deb https://repo.download.nvidia.com/jetson/t194 r32.5 main

FILE=/etc/apt/sources.list.d/nvidia-l4t-apt-source.list

if [ -e $FILE ]; then
	echo "Backing up $FILE"
	sudo mv $FILE /etc/apt/sources.list.d/nvidia-l4t-apt-source.list.save
fi

{
	echo 'deb https://repo.download.nvidia.com/jetson/common r32.5 main ' 
	echo 'deb https://repo.download.nvidia.com/jetson/t194 r32.5 main ' 
 }	| sudo tee /etc/apt/sources.list.d/nvidia-l4t-apt-source.list



sudo apt update
sudo apt dist-upgrade
sudo apt autoremove

#download nomachine armv8 
cd home/$USER/Downloads
wget https://www.nomachine.com/free/arm/v8/deb -O nomachine.deb
#install nomachine 
sudo dpkg -i nomachine.deb


#Simply mounting (or symlinking) the /var/lib/openalpr folder to your external drive would be the simplest

#call the nvme script here

curl -L https://deb.openalpr.com/openalpr.gpg.key | sudo apt-key add -
echo 'deb https://deb.openalpr.com/jetson40/ jetson40 main' | sudo tee /etc/apt/sources.list.d/openalpr.list

#sudo apt-get install libalprneuralgpu2