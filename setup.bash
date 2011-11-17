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

echo "Configuring ZSH"
ln -sf $CONFIGPATH/oh-my-zsh ~/.oh-my-zsh
ln -sf $CONFIGPATH/zshrc ~/.zshrc

echo "Configuring SCREEN"
ln -sf $CONFIGPATH/screenrc ~/.screenrc

echo "Installing VIM plugins"
git submodule update --init

echo "Upgrading VIM plugins (this may be redundant)"
git submodule foreach git pull origin master
