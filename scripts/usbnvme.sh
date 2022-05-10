#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"

#echo 174c:2362:u | sudo tee /sys/module/usb_storage/parameters/quirks
	#lets add a usb3 driver override for LINDY43095 USB to NVME adapter
QUIRKSTRING="174c:2362:u" 
QUIRKLOC="/sys/module/usb_storage/parameters/quirks"
echo -e "$PURPLE Adding the quirk string override of $QUIRKSTRING to $QUIRKLOC $END"

if ! grep -q "$QUIRKSTRING" $QUIRKLOC; then
	#cannot backup the file
	echo -e "$GREEN Inserting  $END"
	echo "$QUIRKSTRING"	| sudo tee $QUIRKLOC
else
	echo -e "$GREEN $QUIRKSTRING is already in quirk $END"
fi
