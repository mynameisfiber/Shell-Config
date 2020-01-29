#!/bin/bash

if ! which git > /dev/null; then
    echo "Please install git"
    exit 1
fi

if ! which rustup > /dev/null; then
    echo "Installing rust"
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    . $HOME/.bashrc
else
    echo "Upgrading rust"
    rustup update stable
fi

scratch=$( mktemp -d -t tmp.XXXXXXXXXX )
echo $scratch
function cleanup {
    echo "Cleaning up";
    rm -rf "$scratch";
}
trap cleanup EXIT

rootdir=`dirname "$(readlink -f "$0")"`/..
mkdir -p $rootdir/deb/

cd $scratch
git clone https://github.com/alacritty/alacritty.git
pushd alacritty
if command -v alacritty > /dev/null 2>&1; then
    cur_version=$( alacritty --version | cut -f2 -d' ' )
    new_version=$( grep -E "^version =" alacritty/Cargo.toml | cut -f2 -d'=' | tr -dc [0-9.] )
    if [ "$cur_version" == "$new_version" ]; then
        echo "Latest version already installed!"
        exit
    fi
    echo "Upgrading alacritty from ${cur_version} to ${new_version}"
fi
cargo build --release
cargo install --force cargo-deb
cargo deb --manifest-path alacritty/Cargo.toml --no-build --install --output $rootdir/deb/
sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
popd
