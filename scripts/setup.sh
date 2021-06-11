#!/bin/bash
#Jetson stuff
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"


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

((!$#)) && echo -e "$RED No arguments supplied. Using all defaults $END" && echo -e "$RED $HELPMSG $END"

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
    echo -e "$RED Username is blank $END"
	exit 
fi

if [ -z $FOLDER ]; then 
    echo -e "$RED Folder is blank $END"
	exit 
fi

if [ ! -d $FOLDER ]; then 
	echo -e "$RED $FOLDER does not exist $END"
	exit 
fi

if [ ! -b $DEV ]; then 
    echo -e "$RED Device $DEV does not exist $END"
	exit 
fi

if [ -z $PART ]; then 
    echo -e "$RED Partition value is blank $END"
	exit 
fi

DEFVALS="Using the following values
Username: $USERNAME
Folder: $FOLDER
Device: $DEV
Partition: $PART
"
echo -e "$GREEN $DEFVALS $END"

#edit sudoers file with : visudo
#    myuser ALL=(ALL) NOPASSWD:ALL

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



#call the nvme script here
./nvme.sh -f $FOLDER -d $DEV -p $PART


#install external programs
./programs.sh
