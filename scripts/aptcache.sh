#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"

echo ""
echo -e "$PURPLE ADD APTCACHE to APT $END"
APTFILE=/etc/apt/apt.conf.d/00aptproxy
IP=192.168.179.168
APTSTRING="Acquire::http::Proxy "http://$IP:3142";"

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