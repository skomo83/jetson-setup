#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"

#moved each program into their own file
echo ""
echo -e "$PURPLE Install custom software? $END"

./nomachine.sh
./openalpr.sh
