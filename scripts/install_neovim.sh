#!/bin/env bash

set -euxo pipefail

VERSION="stable"

if ! which wget > /dev/null; then
    echo "Please install curl"
    exit 1
fi

if [ ! -e ~/bin/ ]; then
    mkdir -p ~/bin/
fi

wget -O ~/bin/nvim.appimage https://github.com/neovim/neovim/releases/download/${VERSION}/nvim-linux-x86_64.appimage
chmod +x ~/bin/nvim.appimage
ln -sf ~/bin/nvim.appimage ~/bin/nvim
