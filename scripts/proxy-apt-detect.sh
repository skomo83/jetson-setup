#!/bin/bash

IP=192.168.179.168
PORT=3142

if nc -zw1 $IP $PORT; then
    echo -n "http://$IP:$PORT"
else
    echo -n "DIRECT"
fi