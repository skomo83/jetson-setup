#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"

echo ""
echo -e "$PURPLE ADD APTPROXY to APT $END"

SCRIPTPATH=/usr/local/bin/
SCRIPTFILE=proxy-apt-detect.sh
SCRIPTLOC=$SCRIPTPATH$SCRIPTFILE
APTFILE=/etc/apt/apt.conf.d/00aptproxy
#APTCACHE=IPADDRESS
HELPMSG="
 Must run with IP address '-c 192.168.179.168' 
"

((!$#)) && echo -e "$RED No arguments supplied! $END" && echo -e "$RED $HELPMSG $END" && exit

while getopts c:h flag
do
    case "${flag}" in
        c) APTCACHE=${OPTARG};;
		h) echo -e "$RED $HELPMSG $END"; exit
    esac
done

if [ -z $APTCACHE ]; then 
    echo -e "$RED APTCACHE is blank $END"
	exit 
fi

if [ ! -e $SCRIPTLOC ]; then
	echo -e "$GREEN Copying $SCRIPTFILE to $SCRIPTPATH $END"
	sudo cp $SCRIPTFILE $SCRIPTPATH
    if [ $? -eq 0 ]; 
    then  
        echo -e "$GREEN $SCRIPTFILE copied successfully to $SCRIPTPATH $END"
    else
        echo -e "$RED $SCRIPTFILE FAILED IN COPYING TO $SCRIPTPATH $END"    
    fi
fi

echo ""
echo -e "$PURPLE Modify script to use correct IP $END"

sed "3s/.*/IP=$APTCACHE/" $SCRIPTLOC

echo ""
echo ""

APTSTRING="Acquire::http::Proxy-Auto-Detect \"$SCRIPTLOC\";"

if [ -f "$APTFILE" ] && grep -q "$APTSTRING" "$APTFILE" ;
then
    echo -e "$GREEN $APTSTRING is already in $APTFILE $END"
else
    echo "$APTSTRING" | sudo tee $APTFILE

    if [ $? -eq 0 ]; 
    then  
        echo -e "$GREEN $APTSTRING added successfully to $APTFILE $END"
    else
        echo -e "$RED $APTSTRING FAILED IN ADDING TO $APTFILE $END"    
    fi
fi