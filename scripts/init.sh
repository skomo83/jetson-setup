#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"

#go to the dir you want your scripts and copy and paste the below
#wget https://raw.githubusercontent.com/skomo83/jetson-setup/main/scripts/init.sh

#flush the dns to ensure we get the latest file changes
sudo systemd-resolve --flush-caches

#yes its ugly manually putting in the files but it works

FILES=("init.sh"  "aptinstalls.sh" "setup.sh" "sudoadd.sh" "storage.sh" "programs.sh" "nvidia.sh" "nomachine.sh" "openalpr.sh" "readme.md")
LOCATION="https://raw.githubusercontent.com/skomo83/jetson-setup/main/scripts/"

for file in ${FILES[@]};
do
    [ -f $file ] && rm $file && echo -e "$RED Deleted $file $END"
    echo -e "$GREEN Downloading $file $END"
    wget $LOCATION$file
    if [[ $file == *.sh ]]; then
        chmod +x $file
    fi
done

exit

#go to the dir you want your scripts and copy and paste the below
wget https://raw.githubusercontent.com/skomo83/jetson-setup/main/scripts/init.sh
chmod +x init.sh
./init.sh

#once done then simply call
./setup.sh
