#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"

echo ""
echo -e "$PURPLE REMOVE APTProxy from APT $END"

APTFILE=/etc/apt/apt.conf.d/00aptproxy

if [ -f "$APTFILE" ];
then
    echo -e "$GREEN The file $APTFILE exists $END"
    sudo bash -c "rm $APTFILE"
    if [ $? -eq 0 ]; 
    then  
        echo -e "$GREEN Removing $APTFILE successful $END"
    else
        echo -e "$RED Removing $APTFILE FAILED $END"    
    fi
else
    echo -e "$GREEN $APTFILE does not exist $APTFILE $END"
    
fi