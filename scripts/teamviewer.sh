#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"

#need to add a check to see if nomachine is already installed
PACKAGE=nomachine
ARMV=$(uname -m | grep -o -E '[0-9]+')

echo ""
echo -e "$PURPLE Checking if $PACKAGE is installed $END"

dpkg -s $PACKAGE &> /dev/null  

if [ $? -ne 0 ]
    then
        echo -e "$RED $PACKAGE is not installed $END" 
        echo -e "$GREEN wget https://download.teamviewer.com/download/linux/teamviewer-host_arm$ARMV.deb -O teamviewer.deb$END"
        wget "https://download.teamviewer.com/download/linux/teamviewer-host_arm$ARMV.deb" -O teamviewer.deb
        sudo dpkg -i teamviewer.deb
    else
        echo -e "$GREEN $PACKAGE is already installed $END"
fi
