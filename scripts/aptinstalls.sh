#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"

echo ""
echo -e "$PURPLE RUN APT UPDATE AND INSTALL EXTRA PROGRAMS $END"
sudo apt update
sudo apt install nano haveged curl apt-transport-https gparted -y

sudo apt dist-upgrade -y
sudo apt autoremove -y