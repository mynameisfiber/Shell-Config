#!/bin/bash

set -euxo pipefail

if ! which git > /dev/null; then
    echo "Please install git"
    exit 1
fi

scratch=$( mktemp -d -t tmp.XXXXXXXXXX )
echo $scratch
function cleanup {
    echo "Cleaning up";
    rm -rf "$scratch";
}
trap cleanup EXIT

cd $scratch

git clone --branch v6.1.0 https://github.com/universal-ctags/ctags.git
cd ctags

./autogen.sh 
./configure
make
sudo make install
