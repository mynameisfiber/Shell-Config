#!/bin/bash

set -e #exit on error

function inject_shell_custom() {
	local toinject=$1
	local customfile=$2
	if [[ ! `grep ". $customfile" $toinject` ]]; then
	    echo -ne "\nif [ -f $customfile ]; then\n  . $customfile \nfi" >> $toinject
	fi
}


echo "*******Installing required python packages"
pip3 install -Ur requirements.txt --user

echo "*******Updating submodules"
git submodule update --init --recursive
git submodule foreach  git pull -f origin master

echo "*******Refreshing dotfiles"
stow -R dotfiles

echo "*******Injecting custom shell profiles"
inject_shell_custom ~/.profile ~/.profile_custom
inject_shell_custom ~/.bashrc ~/.bash_custom
inject_shell_custom ~/.bash_profile ~/.bash_custom

echo "*******Installing LOLssh"
cd lolssh
python setup.py install --user
bash ./install
cd ..

