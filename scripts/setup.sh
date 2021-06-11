#!/bin/bash
#Jetson stuff

USERNAME=$USER
DEV=/dev/nvme0n1
PART=/dev/nvme0n1p1
FOLDER=/var/lib/openalpr

HELPMSG="
default folder is $FOLDER. Overide folder with '-f /folder/location'
current username is $USERNAME. Overide username with '-u username' 
default device is $DEV. Overide device with '-d /dev/device/' 
default partition is $PART. Overide partition with '-p /dev/partition/'
run with -h to display with message
"

((!$#)) && echo "No arguments supplied. Using all defaults" && echo "$HELPMSG"

while getopts u:f:d:p:h flag
do
    case "${flag}" in
        u) USERNAME=${OPTARG};;
        f) FOLDER=${OPTARG};;
		d) DEV=${OPTARG};;
		p) PART=${OPTARG};;
		h) echo "$HELPMSG"; exit
    esac
done

if [ -z $USERNAME ]; then 
	echo "Username is blank"
	exit 
fi

if [ -z $FOLDER ]; then 
	echo "Folder is blank"
	exit 
fi

if [ ! -d $FOLDER ]; then 
	echo "Folder $FOLDER does not exist"
	exit 
fi

if [ ! -b $DEV ]; then 
	echo "Device $DEV does not exist"
	exit 
fi

if [ -z $PART ]; then 
	echo "Partition value is blank"
	exit 
fi

echo "Using the following values"
echo "Username: $USERNAME";
echo "Folder: $FOLDER";
echo "Device: $DEV";
echo "Partition: $PART";


#edit sudoers file with : visudo
#    myuser ALL=(ALL) NOPASSWD:ALL

#USER=user

sudo bash -c 'echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/99_sudo_include_file'    

#Check that your sudoers include file passed the visudo syntax checks:
sudo visudo -cf /etc/sudoers.d/99_sudo_include_file

#now can use sudo

#sudo nano /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
#edit section below so you can update to 32.5.1 jetpack
#t194 for Jetson AGX Xavier series or Jetson Xavier NX
#deb https://repo.download.nvidia.com/jetson/common r32.5 main
#deb https://repo.download.nvidia.com/jetson/t194 r32.5 main

./nvidia.sh

sudo apt update
sudo apt install nano haveged curl apt-transport-https gparted

sudo apt dist-upgrade
sudo apt autoremove

#Simply mounting (or symlinking) the /var/lib/openalpr folder to your external drive would be the simplest

#call the nvme script here
./nvme.sh -f $FOLDER -d $DEV -p $PART


#install external programs
./programs.sh
