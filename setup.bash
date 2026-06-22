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

function setup_suspend_locking() {
    echo "Setting up automatic screen lock on suspend..."

    # System service
    if [ -f "scripts/user-suspend@.service" ]; then
        sudo cp -f "scripts/user-suspend@.service" "/etc/systemd/system/"
        sudo chmod 644 "/etc/systemd/system/user-suspend@.service"
        sudo systemctl daemon-reload
        sudo systemctl enable "user-suspend@${USER}.service"
    fi

    # User service
    mkdir -p "$HOME/.config/systemd/user"
    if [ -f "scripts/lock-before-sleep.service" ]; then
        cp -f "scripts/lock-before-sleep.service" "$HOME/.config/systemd/user/"
        chmod 644 "$HOME/.config/systemd/user/lock-before-sleep.service"
        systemctl --user daemon-reload
        systemctl --user enable lock-before-sleep.service
    fi
}


echo "*******System Packages"
if command -v pacman > /dev/null 2>&1; then
    echo "Updating system"
    sudo pacman -Suy --noconfirm
    echo "Installing system packages"
    sudo pacman -Sy --needed --noconfirm $( cat packages/pacman/requirements.pacman | grep -v "^#" | paste -sd ' ' )
    if [ ! -z "$DISPLAY" ]; then
    	echo "Installing graphical packages"
    	sudo pacman -Sy --needed --noconfirm $( cat packages/pacman/requirements.gui.pacman | grep -v "^#" | paste -sd ' ' )
    fi
    ./scripts/install_yay.sh
fi

if command -v apt > /dev/null 2>&1; then
    _install_requirements "sudo add-apt-repository -yn" packages/dpkg/ppas.conf
    sudo apt update
    _install_requirements "sudo apt -y install" packages/dpkg/requirements.dpkg
    if [ ! -z "$DISPLAY" ]; then
        _install_requirements "sudo apt -y install" packages/dpkg/requirements.gui.dpkg
    fi
fi

echo "*******Updating submodules"
git submodule update --init --recursive --remote --jobs=4

echo "*******Refreshing dotfiles"
stow -R dotfiles

echo "*******Injecting custom shell profiles"
inject_shell_custom ~/.profile ~/.profile_custom
inject_shell_custom ~/.bashrc ~/.bash_custom
inject_shell_custom ~/.bash_profile ~/.bash_custom

echo "*******Installing custom systemd services"
setup_suspend_locking

echo "*******Sourcing bashrc"
#source $HOME/.bashrc
#source $HOME/.profile

echo "*******Installing python"
pushd $(pyenv root)

git checkout master
git pull
popd

PYTHON_VERSION="3.12.3"
export MAKEOPTS="-j"
export CFLAGS="-O2 -fPIC"
export PYTHON_CONFIGURE_OPTS="--enable-loadable-sqlite-extensions"
pyenv install --skip-existing $PYTHON_VERSION
pyenv global $PYTHON_VERSION
pyenv local $PYTHON_VERSION

echo "*******Installing required python packages"
python3 -m ensurepip
python3 -m pip install -U pip
python3 -m pip install --upgrade --force-reinstall -r requirements.txt
if [ ! -z "$DISPLAY" ]; then
    python3 -m pip install --upgrade --force-reinstall -r requirements.gui.txt
fi

echo "******Installing custom built programs"
#./scripts/install_neovim.sh
./scripts/install_nerd_fonts.sh
./scripts/install_universal_ctags.sh

if [ ! -z "$DISPLAY" ]; then
    echo "********Installing lolcommits"
    gem install lolcommits lolcommits-loltext
    lolcommits --enable
fi

#echo "*******Installing LOLssh"
#cd lolssh
#python3 setup.py install --user
#bash ./install
#cd ..

