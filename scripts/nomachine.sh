#need to add a check to see if nomachine is already installed
PACKAGE=nomachine

echo "checking if $PACKAGE is installed"

dpkg -s $PACKAGE &> /dev/null  

if [ $? -ne 0 ]
    then
        echo "$PACKAGE is not installed"  
        wget https://www.nomachine.com/free/arm/v8/deb -O nomachine.deb
        sudo dpkg -i nomachine.deb
    else
        echo "$PACKAGE is already installed"
fi
