#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"

echo ""
echo -e "$PURPLE ADD APTPROXY to APT $END"

APTFILE=/etc/apt/apt.conf.d/00aptproxy
#APTCACHE=192.168.179.168
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

APTSTRING="Acquire::http::Proxy \"http://$APTCACHE:3142\";"

if [ -f "$APTFILE" ] && grep -q "$APTSTRING" "$APTFILE" ;
then
    echo -e "$GREEN $APTSTRING is already in $APTFILE $END"
else
    sudo bash -c "echo '$APTSTRING' >> '$APTFILE'"
    
    if [ $? -eq 0 ]; 
    then  
        echo -e "$GREEN $APTSTRING added successfully to $APTFILE $END"
    else
        echo -e "$RED $APTSTRING FAILED IN ADDING TO $APTFILE $END"    
    fi
fi