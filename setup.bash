#!/bin/bash

CONFIGPATH=`pwd`
mkdir dotfiles/.config/
echo "Config path: $CONFIGPATH"

echo "Configuring VIM"
git mv vimrc dotfiles/.vimrc 
git mv vim dotfiles/.vim


echo "Configuring shell"
git mv profile_custom dotfiles/.profile_custom

git mv bash_custom dotfiles/.bash_custom
git mv inputrc dotfiles/.inputrc

echo "Configuring bin"
git mv bin dotfiles/.bin

echo "Configuring scripts"
git mv bash_scripts dotfiles/.bash_scripts

git mv profile_scripts dotfiles/.profile_scripts

echo "Configuring ZSH"
git mv oh-my-zsh dotfiles/.oh-my-zsh
git mv zshrc dotfiles/.zshrc

echo "Configuring AsciiDoc"
git mv asciidoc dotfiles/.asciidoc

echo "Configuring ctags"
git mv ctags dotfiles/.ctags

echo "Configuring screen layouts"
git mv screenlayouts dotfiles/.screenlayouts

echo "Configuring SCREEN"
git mv screenrc dotfiles/.screenrc

echo "Configuring tmux"
git mv tmux.conf dotfiles/.tmux.conf

echo "Configuring awesome"
git mv awesome dotfiles/.config/awesome
echo "Configuring powerline"
git mv powerline dotfiles/.config/

