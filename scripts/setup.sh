#!/bin/bash
#Jetson stuff
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
LIGHTGREY="\e[37m"
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

if [ ! -b $DEV ]; then 
    echo -e "$RED Device $DEV does not exist $END"
	exit 
fi

if [ -z $PART ]; then 
    echo -e "$RED Partition value is blank $END"
	exit 
fi

echo ""
echo -e "$GREEN Starting the configuration $END"

DEFVALS="
 Using the following values
 Username: $USERNAME
 Folder: $FOLDER
 Device: $DEV
 Partition: $PART
"
echo -e "$GREEN $DEFVALS $END"

#edit sudoers file with : visudo
#    myuser ALL=(ALL) NOPASSWD:ALL
./sudoadd.sh 

#install the new nvidia repo
./nvidia.sh

#run apt update and install some general programs
echo -e "$PURPLE RUN APT UPDATE AND INSTALL EXTRA PROGRAMS $END"
sudo apt update
sudo apt install nano haveged curl apt-transport-https gparted -y

sudo apt dist-upgrade -y
sudo apt autoremove -y


#call the nvme script here
echo -e "$GREEN ./nvme.sh -f $FOLDER -d $DEV -p $PART $END"
./nvme.sh -f $FOLDER -d $DEV -p $PART


#install external programs
./programs.sh

#finished
echo -e "$GREEN Finished Configuration $END"
echo -e "$LIGHTGREY Please perform a restart ! $END"
