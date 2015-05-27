#!/bin/bash

CONFIGPATH=`pwd`
echo "Config path: $CONFIGPATH"

echo "Configuring VIM"
mv ~/.vimrc ~/.vimrc.bak
ln -sf $CONFIGPATH/vimrc ~/.vimrc 
mv ~/.vim ~/.vim.bak
ln -sf $CONFIGPATH/vim ~/.vim


echo "Configuring shell"
mv ~/.profile_custom ~/.profile_custom.bak
ln -sf $CONFIGPATH/profile_custom ~/.profile_custom
echo "Configuring general profile"
if [[ ! `grep ". ~/.profile_custom" ~/.profile` ]]; then
    echo -ne "if [ -f ~/.profile_custom ]; then\n  . ~/.profile_custom \nfi" >> ~/.profile
fi

mv ~/.bash_custom ~/.bash_custom.bak
ln -sf $CONFIGPATH/bash_custom ~/.bash_custom
if [[ ! `grep ". ~/.bash_custom" ~/.bashrc` ]]; then
    echo -ne "if [ -f ~/.bash_custom ]; then\n  . ~/.bash_custom \nfi" >> ~/.bashrc
fi
if [[ ! `grep ". ~/.bash_custom" ~/.bash_profile` ]]; then
    echo -ne "if [ -f ~/.bash_custom ]; then\n  . ~/.bash_custom \nfi" >> ~/.bash_profile
fi
mv ~/.inputrc ~/.inputrc.bak
ln -sf $CONFIGPATH/inputrc ~/.inputrc

echo "Configuring bin"
mv ~/.bin ~/.bin.bak
rm ~/.bin
ln -sfF $CONFIGPATH/bin ~/.bin

echo "Configuring scripts"
mv ~/.bash_scripts ~/.bash_scripts.bak
rm ~/.bash_scripts
ln -sfF $CONFIGPATH/bash_scripts ~/.bash_scripts

mv ~/.profile_scripts ~/.profile_scripts.bak
rm ~/.profile_scripts
ln -sfF $CONFIGPATH/profile_scripts ~/.profile_scripts

echo "Configuring ZSH"
mv ~/.oh-my-zsh ~/.oh-my-zsh.bak
ln -sf $CONFIGPATH/oh-my-zsh ~/.oh-my-zsh
mv ~/.zshrc ~/.zshrc.bak
ln -sf $CONFIGPATH/zshrc ~/.zshrc

echo "Configuring AsciiDoc"
mv ~/.asciidoc ~/.asciidoc.bak
ln -sf $CONFIGPATH/asciidoc ~/.asciidoc

echo "Configuring screen layouts"
mv ~/.screenlayouts ~/.screenlayouts.bak
ln -sf $CONFIGPATH/screenlayouts ~/.screenlayouts

echo "Configuring SCREEN"
mv ~/.screenrc ~/.screenrc.bak
ln -sf $CONFIGPATH/screenrc ~/.screenrc

echo "Configuring awesome"
mv ~/.config/awesome ~/.config/awesome.bak
ln -sf $CONFIGPATH/awesome ~/.config/awesome

echo "Installing required python packages"
pip install -r requirements.txt --user

echo "Configuring git"
mv ~/.gitconfig ~/.gitconfig.bak
cat $CONFIGPATH/gitconfig | sed s:{{CONFIGPATH}}:$CONFIGPATH:g > ~/.gitconfig

echo "Installing VIM plugins"
git submodule update --init --recursive

echo "Upgrading VIM plugins (this may be redundant)"
git submodule foreach --recursive git pull origin master

echo "Installing LOLssh"
pushd lolssh
python setup.py install --user
bash ./install
popd
