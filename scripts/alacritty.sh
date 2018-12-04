#!/bin/bash

if ! which git > /dev/null; then
    echo "Please install git"
    exit 1
fi

if ! which rustup > /dev/null; then
    echo "Installing rust"
    curl https://sh.rustup.rs -sSf | sh -s -- -y
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
git clone https://github.com/jwilm/alacritty.git
cd alacritty
cargo build --release
cargo install cargo-deb
cargo deb --no-build --install --output $rootdir/deb/
