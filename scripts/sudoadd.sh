#!/bin/bash
RED="\e[31m"
GREEN="\e[32m"
PURPLE="\e[35m"
END="\e[0m"

echo -e "$PURPLE ADD $USERNAME to SUDOERS $END"
sudo bash -c "echo '$USERNAME ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/99_sudo_include_file"   

#Check that your sudoers include file passed the visudo syntax checks:
sudo visudo -cf /etc/sudoers.d/99_sudo_include_file
