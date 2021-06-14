#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"

USERNAME=$USER

HELPMSG="
 current username is $USERNAME. Overide username with '-u username' 
 run with -h to display this message
"

((!$#)) && echo -e "$RED No arguments supplied. Using all defaults $END" && echo -e "$RED $HELPMSG $END"

while getopts u:h flag
do
    case "${flag}" in
        u) USERNAME=${OPTARG};;
		h) echo "$HELPMSG"; exit
    esac
done

if [ -z $USERNAME ]; then 
    echo -e "$RED Username is blank $END"
	exit 
fi

echo -e "$PURPLE ADD $USERNAME to SUDOERS $END"
SUDOFILE=/etc/sudoers.d/99_sudo_include_file

SUDOSTRING="$USERNAME ALL=(ALL) NOPASSWD:ALL"
if ! grep -q "$SUDOSTRING" $SUDOFILE; then
    sudo bash -c "echo $SUDOSTRING >> $SUDOFILE"
    sudo visudo -cf $SUDOFILE
else
    echo -e "$GREEN $SUDOSTRING is already in $SUDOFILE $END"
fi

#sudo bash -c "echo $SUDOSTRING >> /etc/sudoers.d/99_sudo_include_file"   

#Check that your sudoers include file passed the visudo syntax checks:
#sudo visudo -cf /etc/sudoers.d/99_sudo_include_file
