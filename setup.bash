#!/bin/bash

set -e #exit on error

function inject_shell_custom() {
	local toinject=$1
	local customfile=$2
	if [[ ! `grep ". $customfile" $toinject` ]]; then
	    echo -ne "\nif [ -f $customfile ]; then\n  . $customfile \nfi" >> $toinject
	fi
}

function apt_install_requirements() {
    local requirements=$1
    local pkg_list=$( cat $requirements | grep -Ev '(#|^$)' | paste -d' ' -s - )
    echo "Installing packages: $pkg_list"
    sudo apt install $pkg_list
}

echo "*******System Packages"
if command -v apt > /dev/null 2>&1; then
    apt_install_requirements requirements.dpkg
    if [ ! -z "$DISPLAY" ]; then
        apt_install_requirements requirements.gui.dpkg
    fi
fi


echo "*******Refreshing dotfiles"
stow -R dotfiles
. $HOME/.bashrc

echo "*******Installing python"
pyenv install --skip-existing 3.7.2
pyenv global 3.7.2

echo "*******Installing required python packages"
pip3 install -U --user pip
pip3 install -Ur requirements.txt --user

echo "*******Updating submodules"
git config --global core.excludesfile '~/.gitignore'
git submodule update --init --recursive --remote

echo "*******Injecting custom shell profiles"
inject_shell_custom ~/.profile ~/.profile_custom
inject_shell_custom ~/.bashrc ~/.bash_custom
inject_shell_custom ~/.bash_profile ~/.bash_custom

#echo "*******Installing LOLssh"
#cd lolssh
#python3 setup.py install --user
#bash ./install
#cd ..

