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
        $1 $package
    done)
}

echo "*******System Packages"
if command -v apt > /dev/null 2>&1; then
    _install_requirements "sudo add-apt-repository -yn" ppas.conf
    sudo apt update
    _install_requirements "sudo apt -y install" requirements.dpkg
    if [ ! -z "$DISPLAY" ]; then
        _install_requirements "sudo apt -y install" requirements.gui.dpkg
    fi
fi
if command -v snap > /dev/null 2>&1; then
    if [ ! -z "$DISPLAY" ]; then
        _install_requirements "sudo snap install" requirements.gui.snap
    fi
fi


echo "*******Refreshing dotfiles"
stow -R dotfiles

echo "*******Injecting custom shell profiles"
inject_shell_custom ~/.profile ~/.profile_custom
inject_shell_custom ~/.bashrc ~/.bash_custom
inject_shell_custom ~/.bash_profile ~/.bash_custom

echo "*******Sourcing bashrc"
#source $HOME/.bashrc

echo "*******Installing python"
export MAKEOPTS="-j"
export CFLAGS="-O2"
export PYTHON_CONFIGURE_OPTS="--enable-loadable-sqlite-extensions"
pushd $(pyenv root)

git checkout master
git pull
popd

pyenv install --skip-existing 3.7.4
pyenv install --skip-existing 3.8.6
pyenv global 3.8.6 3.7.4

echo "*******Installing required python packages"
python3 -m pip install -U --user pip
python3 -m pip install --upgrade --force-reinstall -r requirements.txt --user

if [ ! -z "$DISPLAY" ]; then
    echo "********Installing lolcommits"
    gem install --user lolcommits lolcommits-loltext
fi

echo "*******Updating submodules"
git config --global core.excludesfile '~/.gitignore'
git submodule update --init --recursive --remote --jobs=-1

#echo "*******Installing LOLssh"
#cd lolssh
#python3 setup.py install --user
#bash ./install
#cd ..

