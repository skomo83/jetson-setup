#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"

#echo 174c:2362:u | sudo tee /sys/module/usb_storage/parameters/quirks
	#lets add a usb3 driver override for LINDY43095 USB to NVME adapter
QUIRKSTRING="usb_storage.quirks=0x174c:0x2362:u" 
QUIRKLOC="/boot/extlinux/extlinux.conf"
BACKUPLOC="/home/localadmin/Downloads/"
echo -e "$PURPLE Adding the usb_storage.quirk override of $QUIRKSTRING to $QUIRKLOC $END"

if ! grep -q "$QUIRKSTRING" $QUIRKLOC; then
	echo -e "$GREEN Making backup of extlinux.conf $END"
	sudo cp $QUIRKLOC $BACKUPLOC
	#echo -e "$GREEN Inserting  $END"
	#echo "$QUIRKSTRING"	| sudo tee $QUIRKLOC
else
	echo -e "$GREEN $QUIRKSTRING is already in quirk $END"
fi
