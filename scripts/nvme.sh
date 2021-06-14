#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"

#we can uncomment these out when using the file directly but we are getting called from setup.sh with default values
#DEV=/dev/nvme0n1
#PART=/dev/nvme0n1p1
#FOLDER=/var/lib/openalpr
echo ""
echo -e "$PURPLE Setup NVME drive and mount point $END"

HELPMSG="
 Must run with -f /folder/location -d /dev/device/ -p /dev/partition/
"

((!$#)) && echo -e "$RED No arguments supplied! $END" && echo -e "$RED $HELPMSG $END" && exit

while getopts u:f:d:p:h flag
do
    case "${flag}" in
        f) FOLDER=${OPTARG};;
		d) DEV=${OPTARG};;
		p) PART=${OPTARG};;
		h) echo -e "$RED $HELPMSG $END"; exit
    esac
done

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


VALS="
 Using the following values
 Folder: $FOLDER
 Device: $DEV
 Partition: $PART
"
echo -e "$GREEN $VALS $END"

#need to check if the arg is parsed

echo -e "$PURPLE Do we have $DEV connected ?$END"
#is the device there ?
if [ -b $DEV ]; then
	echo -e "$GREEN $DEV is connected $END"
	
	#is the partition created ?
    echo -e "$PURPLE Do we have $PART created ?$END"
    if [ ! -e $PART ]; then
		echo -e "$GREEN Creating partition $END"
		sudo parted $DEV mklabel gpt 
		sudo parted $DEV mkpart primary ext4 0% 100%
		sudo mkfs.ext4 $PART
	else
		echo -e "$GREEN $PART already exists$END"
	fi
	
	#have we created the folder ?
    echo -e "$PURPLE Do we have $FOLDER created ?$END"
	if [ ! -d $FOLDER ]; then
		echo -e "$GREEN Creating $FOLDER $END"
		sudo mkdir $FOLDER;
	else
		echo  -e "$GREEN $FOLDER already exists $END"
	fi
	
	#lets mount the partition to the folder
    echo -e "$PURPLE Lets try mount $FOLDER to $PART $END"
	if ([ -e $PART ] && [ -d $FOLDER ]); then
		echo -e "$GREEN Mounting $FOLDER to $PART $END"
		sudo mount $PART $FOLDER
    else
        echo -e "$RED Problem occured with either $FOLDER or $PART $END"
	fi
	
	#lets enable auto mount in fstab
    echo -e "$PURPLE Adding the auto mount of $FOLDER to $PART in FSTAB $END"
	if ! grep -q '#2TB' /etc/fstab; then
		echo -e "$GREEN Making backup of fstab $END"
		sudo cp /etc/fstab /etc/fstab.backup
		echo -e "$GREEN Inserting 2TB drive into fstab $END"
		
		{
		echo "#2TB" 
		echo "$PART    $FOLDER    ext4    defaults    0    2" 
 		}	| sudo tee /etc/fstab

	else
		echo -e "$GREEN #2TB is already in fstab $END"
	fi
else
	echo -e "$RED $DEV is NOT connected ! $END"
fi

