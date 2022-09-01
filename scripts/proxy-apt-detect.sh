#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"

#IP=192.168.88.1
PORT=3142

HELPMSG="
 Must run with IP address '-i IPADDRESS' and Port '-p 3142' 
"

((!$#)) && echo -n "DIRECT"

while getopts i:p:h flag
do
    case "${flag}" in
        i) IP=${OPTARG};;
		p) PORT=${OPTARG};;
		h) echo -e "$RED $HELPMSG $END"; exit
    esac
done

if nc -w1 -z $IP $PORT; then
    echo -n "http://${IP}:${PORT}"
else
    echo -n "DIRECT"
fi