#!/bin/bash
DEV=/dev/nvme0n1
PART=/dev/nvme0n1p1
FOLDER=/var/lib/openalpr

if [ -e $DEV ]; then
	echo "$DEV is connected"
	if [ ! -e $PART ]; then
		echo "Creating partition"
		sudo parted $DEV mklabel gpt 
		sudo parted $DEV mkpart primary ext4 0 100%
		sudo mkfs.ext4 $PART
	else
		echo "$PART already exists"
	fi
	
	if [ ! -d $FOLDER ]; then
		echo "Creating $FOLDER"
		sudo mkdir $FOLDER;
	else
		echo "$FOLDER already exists"
	fi
	
	if ([ -e $PART ] && [ -d $FOLDER ]); then
		echo "mounting $FOLDER to $PART"
		sudo mount $PART $FOLDER
	fi
	
	if ! grep -q '#2TB' /etc/fstab; then
		echo "Making backup of fstab"
		sudo cp /etc/fstab /etc/fstab.backup
		echo "Inserting 2TB drive into fstab"
		echo '#2TB' >> /etc/fstab
		echo "$PART    $FOLDER    ext4    defaults    0    2" >> /etc/fstab
	else
		echo "#2TB already in fstab"
	fi
else
	echo "$DEV is NOT connected !"
fi
echo "Finished"
