#!/bin/bash

#go to the dir you want your scripts and copy and paste the below
#wget https://raw.githubusercontent.com/skomo83/jetson-setup/main/scripts/init.sh

#yes its ugly manually putting in the files but it works

FILES=("init.sh" "setup.sh" "nvme.sh" "programs.sh" "nvidia.sh" "nomachine.sh" "openalpr.sh")
LOCATION="https://raw.githubusercontent.com/skomo83/jetson-setup/main/scripts/"

for file in ${FILES[@]};
do
    [ -f $file ] && rm $file && echo "$file deleted"
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
