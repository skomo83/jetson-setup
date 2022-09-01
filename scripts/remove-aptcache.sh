#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"

echo ""
echo -e "$PURPLE REMOVE APTProxy from APT $END"

APTFILE=/etc/apt/apt.conf.d/00aptproxy
SCRIPTFILE=/usr/local/bin/proxy-apt-detect.sh

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
    echo -e "$GREEN $APTFILE does not exist $END"
    
fi

echo -e "$PURPLE REMOVE SCRIPT FILE from APT $END"
if [ -f "$SCRIPTFILE" ];
then
    echo -e "$GREEN The file $SCRIPTFILE exists $END"
    sudo bash -c "rm $SCRIPTFILE"
    if [ $? -eq 0 ]; 
    then  
        echo -e "$GREEN Removing $SCRIPTFILE successful $END"
    else
        echo -e "$RED Removing $SCRIPTFILE FAILED $END"    
    fi
else
    echo -e "$GREEN $SCRIPTFILE does not exist $END"
    
fi