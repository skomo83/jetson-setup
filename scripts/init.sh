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

FILES=("init.sh"  "aptinstalls.sh" "aptcache.sh" "remove-aptcache.sh" "proxy-apt-detect.sh" "setup.sh" "sudoadd.sh" "storage.sh" "programs.sh" "nvidia.sh" "nomachine.sh" "openalpr.sh" "teamviewer.sh")
LOCATION="https://raw.githubusercontent.com/skomo83/jetson-setup/main/scripts/"
README="README.md"
READMELOC="https://raw.githubusercontent.com/skomo83/jetson-setup/main/"


for file in ${FILES[@]};
do
    [ -f $file ] && rm $file && echo -e "$RED Deleted $file $END"
    echo -e "$GREEN Downloading $file $END"
    wget $LOCATION$file
    chmod +x $file
done

rm $README && echo -e "$RED Deleted $README $END"
echo -e "$GREEN Downloading $README $END"
wget $READMELOC$README

exit

#go to the dir you want your scripts and copy and paste the below
wget https://raw.githubusercontent.com/skomo83/jetson-setup/main/scripts/init.sh
chmod +x init.sh
./init.sh

#once done then simply call
./setup.sh
