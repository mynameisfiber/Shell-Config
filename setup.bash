#!/bin/bash

set -e #exit on error

function inject_shell_custom() {
	local toinject=$1
	local customfile=$2
	if [[ ! `grep ". $customfile" $toinject` ]]; then
	    echo -ne "\nif [ -f $customfile ]; then\n  . $customfile \nfi" >> $toinject
	fi
}

function _install_requirements() {
    local method=$1
    local requirements=$2
    echo "Installing packages: $( cat $requirements | grep -Ev '(#|^$)' | paste -d' ' -s - )"
    cat $requirements | grep -Ev '(#|^$)' | (while read package; do
        sudo $1 install $package
    done)
}

echo "*******System Packages"
if command -v apt > /dev/null 2>&1; then
    _install_requirements "apt -y" requirements.dpkg
    if [ ! -z "$DISPLAY" ]; then
        _install_requirements "apt -y" requirements.gui.dpkg
    fi
fi
if command -v snap > /dev/null 2>&1; then
    if [ ! -z "$DISPLAY" ]; then
        _install_requirements snap requirements.gui.snap
    fi
fi


echo "*******Refreshing dotfiles"
stow -R dotfiles

echo "*******Injecting custom shell profiles"
inject_shell_custom ~/.profile ~/.profile_custom
inject_shell_custom ~/.bashrc ~/.bash_custom
inject_shell_custom ~/.bash_profile ~/.bash_custom

echo "*******Sourcing bashrc"
. $HOME/.bashrc

echo "*******Installing python"
export MAKEOPTS="-j"
export CFLAGS="-O2"
export PYTHON_CONFIGURE_OPTS="--enable-loadable-sqlite-extensions"
pyenv install --skip-existing 3.7.2
pyenv global 3.7.2

echo "*******Installing required python packages"
pip3 install -U --user pip
pip3 install --upgrade --force-reinstall -r requirements.txt --user

if [ ! -z "$DISPLAY" ]; then
    echo "********Installing lolcommits"
    gem install --user lolcommits lolcommits-loltext
fi

echo "*******Updating submodules"
git config --global core.excludesfile '~/.gitignore'
git submodule update --init --recursive --remote --njobs=-1

#echo "*******Installing LOLssh"
#cd lolssh
#python3 setup.py install --user
#bash ./install
#cd ..

