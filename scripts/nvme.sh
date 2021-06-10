#!/bin/bash
DEV=/dev/nvme0n1
PART=/dev/nvme0n1p1
#FOLDER=/var/lib/openalpr

while getopts f: FLAG
do
    case "${FLAG}" in
        f) FOLDER=${OPTARG};;
    esac
done

#need to check if the arg is parsed

echo "Do we have $DEV connected ?"
if [ -e $DEV ]; then
	echo "$DEV is connected"
	
    echo "Do we have $PART created ?"
    if [ ! -e $PART ]; then
		echo "Creating partition"
		sudo parted $DEV mklabel gpt 
		sudo parted $DEV mkpart primary ext4 0 100%
		sudo mkfs.ext4 $PART
	else
		echo "$PART already exists"
	fi
	
    echo "Do we have $FOLDER created ?"
	if [ ! -d $FOLDER ]; then
		echo "Creating $FOLDER"
		sudo mkdir $FOLDER;
	else
		echo "$FOLDER already exists"
	fi
	
    echo "Lets try mount $FOLDER to $PART"
	if ([ -e $PART ] && [ -d $FOLDER ]); then
		echo "Mounting $FOLDER to $PART"
		sudo mount $PART $FOLDER
    else
        echo "Problem occured with either $FOLDER or $PART"
	fi
	
    echo "Adding the auto mount of $FOLDER to $PART in FSTAB"
	if ! grep -q '#2TB' /etc/fstab; then
		echo "Making backup of fstab"
		sudo cp /etc/fstab /etc/fstab.backup
		echo "Inserting 2TB drive into fstab"
		echo '#2TB' >> /etc/fstab
		echo "$PART    $FOLDER    ext4    defaults    0    2" >> /etc/fstab
	else
		echo "#2TB is already in fstab"
	fi
else
	echo "$DEV is NOT connected !"
fi
echo "Finished"
