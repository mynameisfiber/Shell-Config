#!/bin/bash

CONFIGPATH=`pwd`
echo "Config path: $CONFIGPATH"

echo "Configuring VIM"
ln -sf $CONFIGPATH/vimrc ~/.vimrc 
ln -sf $CONFIGPATH/vim ~/.vim

echo "Configuring BASH"
if [[ ! `grep ". $CONFIGPATH/bash_custom" ~/.bashrc` ]]; then
    echo -ne "if [ -f $CONFIGPATH/bash_custom ]; then\n  . $CONFIGPATH/bash_custom \nfi" >> ~/.bashrc
fi

echo "Configuring SCREEN"
ln -sf $CONFIGPATH/screenrc ~/.screenrc
