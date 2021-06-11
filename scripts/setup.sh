#!/bin/bash
#Jetson stuff

DEV=/dev/nvme0n1
PART=/dev/nvme0n1p1

((!$#)) && echo "No arguments supplied!" && echo "Must run with -u username -f /folder/location " && echo "overide device with -d /dev/device/ " && echo "overide partition with -p /dev/partition/ "&& exit

while getopts u:f:d:p:h flag
do
    case "${flag}" in
        u) USERNAME=${OPTARG};;
        f) FOLDER=${OPTARG};;
		d) DEV=${OPTARG};;
		p) PART=${OPTARG};;
		h) echo "Must run with -u username -f /folder/location "; exit
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

#need to add a check to see if nomachine is already installed
PACKAGE=nomachine
dpkg -s $PACKAGE &> /dev/null  
if [ $? -ne 0 ]
    then
        echo "$PACKAGE is not installed"  
        wget https://www.nomachine.com/free/arm/v8/deb -O nomachine.deb
        sudo dpkg -i nomachine.deb
    else
        echo "$PACKAGE is already installed"
fi

#need to add a check to see if openalpr is already installed
PACKAGE = openalpr
dpkg -s $PACKAGE &> /dev/null  
if [ $? -ne 0 ]
    then
        echo "$PACKAGE is not installed"  
        echo "Running dummy install"
       # curl -L https://deb.openalpr.com/openalpr.gpg.key | sudo apt-key add -
       # echo 'deb https://deb.openalpr.com/jetson40/ jetson40 main' | sudo tee /etc/apt/sources.list.d/openalpr.list
    else
        echo "$PACKAGE is already installed"
fi

#sudo apt-get install libalprneuralgpu2