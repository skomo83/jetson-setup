#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"

#need to add a check to see if openalpr is already installed
PACKAGE=openalpr

echo ""
echo -e "$PURPLE Checking if $PACKAGE is installed $END"

dpkg -s $PACKAGE &> /dev/null

if [ $? -ne 0 ]
    then
        echo -e "$RED $PACKAGE is not installed $END"  
        curl -L https://deb.openalpr.com/openalpr.gpg.key | sudo apt-key add -
        echo 'deb https://deb.openalpr.com/jetson40/ jetson44 main' | sudo tee /etc/apt/sources.list.d/openalpr.list
        bash <(curl -s https://deb.openalpr.com/install)  # select "install_agent"

    else
        echo -e "$GREEN $PACKAGE is already installed $END"
fi

#sudo apt-get install libalprneuralgpu2
#Simply mounting (or symlinking) the /var/lib/openalpr folder to your external drive would be the simplest