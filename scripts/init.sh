#!/bin/bash

#go to the dir you want your scripts and copy and paste the below
#wget https://raw.githubusercontent.com/skomo83/jetson-setup/main/scripts/init.sh

FILES=("setup.sh" "nvme.sh" "programs.sh")
LOCATION = "https://raw.githubusercontent.com/skomo83/jetson-setup/main/scripts/"

for file in ${FILES[@]};
do
    [ -f $file ] && rm $file
    wget $LOCATION$file
    chmod +x $file
done

exit

#go to the dir you want your scripts and copy and paste the below
wget https://raw.githubusercontent.com/skomo83/jetson-setup/main/scripts/init.sh
chmod +x init.sh
./init.sh

#once done then simply call
./setup.sh
