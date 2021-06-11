#need to add a check to see if openalpr is already installed
PACKAGE=openalpr

echo "checking if $PACKAGE is installed"

dpkg -s $PACKAGE &> /dev/null

if [ $? -ne 0 ]
    then
        echo "$PACKAGE is not installed"  
        echo "Running dummy install"
       # curl -L https://deb.openalpr.com/openalpr.gpg.key | sudo apt-key add -
       # echo 'deb https://deb.openalpr.com/jetson40/ jetson40 main' | sudo tee /etc/apt/sources.list.d/openalpr.list
    else
        echo "$PACKAGE is already installed"
fi

#sudo apt-get install libalprneuralgpu2