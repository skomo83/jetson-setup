#!/bin/bash
#Jetson stuff
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
LIGHTGREY="\e[37m"
END="\e[0m"

#t194 for Jetson AGX Xavier series or Jetson Xavier NX
#t186 for Jetson TX2
#t210 is for Jetson TX1 and Nano series
#current jetpack is r32.6

USERNAME=$USER
#DEV=/dev/nvme0n1
#PART=/dev/nvme0n1p1
#sda is used on NX due to USB to NVME caddy
DEV=/dev/sda
PART=/dev/sda1
FOLDER=/var/lib/openalpr
JETSON=NX
DEVICE=t194
JETPACK=r32.6

HELPMSG="
 default folder is $FOLDER. Overide folder with '-f /folder/location'
 current username is $USERNAME. Overide username with '-u username' 
 default device is $DEV. Overide device with '-d /dev/device/' 
 default partition is $PART. Overide partition with '-p /dev/partition/'
 default jetson is $JETSON. Override jetson type with '-j TX2'
 run with -h to display with message
"

((!$#)) && echo -e "$RED No arguments supplied. Using all defaults $END" && echo -e "$RED $HELPMSG $END"

while getopts u:f:d:p:j:h flag
do
    case "${flag}" in
        u) USERNAME=${OPTARG};;
        f) FOLDER=${OPTARG};;
		d) DEV=${OPTARG};;
		p) PART=${OPTARG};;
        j) JETSON=${OPTARG};;
		h) echo "$HELPMSG"; exit
    esac
done

if [ -z $JETSON ]; then 
    echo -e "$RED Jetson value is blank $END"
	exit 
fi

if [ $JETSON = TX2 ]; then 
    DEV=/dev/sda
    PART=/dev/sda1
    DEVICE=t186
elif [ $JETSON = NX ]; then
    DEV=/dev/sda
    PART=/dev/sda1
    DEVICE=t194
elif [ $JETSON = AGX ]; then
    DEV=/dev/nvme0n1
    PART=/dev/nvme0n1p1
    DEVICE=t194
else
    echo -e "$RED Jetson value not TX2, NX or AGX $END"
	exit 
fi

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
 Jetson: $JETSON
"
echo -e "$GREEN $DEFVALS $END"

#edit sudoers file with : visudo
#    myuser ALL=(ALL) NOPASSWD:ALL
./sudoadd.sh 


#install the new nvidia repo
./nvidia.sh -j $JETPACK -d $DEVICE


#run apt update and install some general programs
./aptinstalls.sh


#call the storage script here
echo -e "$GREEN ./storage.sh -f $FOLDER -d $DEV -p $PART $END"
./storage.sh -f $FOLDER -d $DEV -p $PART


#install external programs
./programs.sh


#finished
echo -e "$GREEN Finished Configuration $END"
echo -e "$LIGHTGREY Please perform a restart ! $END"
