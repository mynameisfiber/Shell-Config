#!/bin/bash

set -euxo pipefail

VERSION=v3.2.1
FONTS=( "0xProto" "Gohu" "Hack" )

if ! which wget > /dev/null; then
    echo "Please install curl"
    exit 1
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
mkdir -p ~/.local/share/fonts/
for font in "${FONTS[@]}"; do
    wget https://github.com/ryanoasis/nerd-fonts/releases/download/${VERSION}/${font}.tar.xz
    tar xvf ${font}.tar.xz -C ~/.local/share/fonts/
done
fc-cache -f -v

