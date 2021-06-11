NVFILE=/etc/apt/sources.list.d/nvidia-l4t-apt-source.list
JETPACK=r32.5
echo "Modifiying the nvidia repo to the Jetpack v $JETPACK"

if [ -e $NVFILE ]; then
	echo "Backing up $NVFILE"
	sudo mv $NVFILE $NVFILE.save
fi

{
	echo "deb https://repo.download.nvidia.com/jetson/common $JETPACK main " 
	echo "deb https://repo.download.nvidia.com/jetson/t194 $JETPACK main " 
 }	| sudo tee $NVFILE