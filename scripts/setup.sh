#!/bin/bash
#Jetson stuff

USERNAME=$USER
DEV=/dev/nvme0n1
PART=/dev/nvme0n1p1

HELPMSG="
Must run with '-f /folder/location'
default username is current user. overide username with '-u username' 
default device is '/dev/nvme0n1' - overide device with '-d /dev/device/' 
default partition is '/dev/nvme0n1p1' - overide partition with '-p /dev/partition/'
"

((!$#)) && echo "No arguments supplied!" && echo "$HELPMSG" && exit

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

if [ ! -b $PART ]; then 
	echo "Partition $PART does not exist"
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
    
sudo apt install nano haveged curl apt-transport-https gparted

#sudo nano /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
#edit section below so you can update to 32.5.1 jetpack
#t194 for Jetson AGX Xavier series or Jetson Xavier NX
#deb https://repo.download.nvidia.com/jetson/common r32.5 main
#deb https://repo.download.nvidia.com/jetson/t194 r32.5 main

NVFILE=/etc/apt/sources.list.d/nvidia-l4t-apt-source.list

if [ -e $NVFILE ]; then
	echo "Backing up $NVFILE"
	sudo mv $NVFILE $NVFILE.save
fi

{
	echo 'deb https://repo.download.nvidia.com/jetson/common r32.5 main ' 
	echo 'deb https://repo.download.nvidia.com/jetson/t194 r32.5 main ' 
 }	| sudo tee $NVFILE

sudo apt update
sudo apt dist-upgrade
sudo apt autoremove

#Simply mounting (or symlinking) the /var/lib/openalpr folder to your external drive would be the simplest

#call the nvme script here
sudo ./nvme.sh -f $FOLDER -d $DEV -p $PART

#install external programs
sudo ./programs.sh