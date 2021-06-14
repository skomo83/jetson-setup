#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"

#sudo nano /etc/apt/sources.list.d/nvidia-l4t-apt-source.list
#edit section below so you can update to 32.5.1 jetpack
#t194 for Jetson AGX Xavier series or Jetson Xavier NX
#deb https://repo.download.nvidia.com/jetson/common r32.5 main
#deb https://repo.download.nvidia.com/jetson/t194 r32.5 main

NVFILE=/etc/apt/sources.list.d/nvidia-l4t-apt-source.list
JETPACK=r32.5
echo ""
echo -e "$GREEN Modifiying the nvidia repo to the Jetpack v $JETPACK $END"

if [ -e $NVFILE ]; then
	echo -e "$GREEN Backing up $NVFILE $END"
	sudo mv $NVFILE $NVFILE.save
fi

{
	echo "deb https://repo.download.nvidia.com/jetson/common $JETPACK main " 
	echo "deb https://repo.download.nvidia.com/jetson/t194 $JETPACK main " 
 }	| sudo tee $NVFILE