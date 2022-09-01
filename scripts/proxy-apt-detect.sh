#!/bin/bash

IP=IPADDRESS
PORT=3142

if nc -zw1 $IP $PORT; then
    echo -n "http://$IP:$PORT"
else
    echo -n "DIRECT"
fi
