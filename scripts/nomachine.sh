#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"

#need to add a check to see if nomachine is already installed
PACKAGE=nomachine

echo -e "$PURPLE Checking if $PACKAGE is installed $END"

dpkg -s $PACKAGE &> /dev/null  

if [ $? -ne 0 ]
    then
        echo -e "$RED $PACKAGE is not installed"  
        wget https://www.nomachine.com/free/arm/v8/deb -O nomachine.deb
        sudo dpkg -i nomachine.deb
    else
        echo -e "$GREEN $PACKAGE is already installed"
fi
