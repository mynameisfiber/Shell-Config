#!/bin/bash

CONFIGPATH=`pwd`
echo "Config path: $CONFIGPATH"

echo "Configuring VIM"
mv ~/.vimrc ~/.vimrc.bak
ln -sf $CONFIGPATH/vimrc ~/.vimrc 
mv ~/.vim ~/.vim.bak
ln -sf $CONFIGPATH/vim ~/.vim

echo "Configuring BASH"
if [[ ! `grep ". $CONFIGPATH/bash_custom" ~/.bashrc` ]]; then
    echo -ne "if [ -f $CONFIGPATH/bash_custom ]; then\n  . $CONFIGPATH/bash_custom \nfi" >> ~/.bashrc
fi
if [[ ! `grep ". $CONFIGPATH/bash_custom" ~/.bash_profile` ]]; then
    echo -ne "if [ -f $CONFIGPATH/bash_custom ]; then\n  . $CONFIGPATH/bash_custom \nfi" >> ~/.bash_profile
fi
mv ~/.inputrc ~/.inputrc.bak
ln -sf $CONFIGPATH/inputrc ~/.inputrc

echo "Configuring ZSH"
mv ~/.oh-my-zsh ~/.oh-my-zsh.bak
ln -sf $CONFIGPATH/oh-my-zsh ~/.oh-my-zsh
mv ~/.zshrc ~/.zshrc.bak
ln -sf $CONFIGPATH/zshrc ~/.zshrc

echo "Configuring SCREEN"
mv ~/.screenrc ~/.screenrc.bak
ln -sf $CONFIGPATH/screenrc ~/.screenrc

echo "Installing VIM plugins"
git submodule update --init

echo "Upgrading VIM plugins (this may be redundant)"
git submodule foreach git pull origin master
