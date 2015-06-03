#!/bin/env zsh

#  Vim

# Install Vundle if not already installed
[ ! -d "~/.vim/bundle/Vundle.vim" ] && git clone \
    https://github.com/gmarik/Vundle.vim.git \
    ~/.vim/bundle/Vundle.vim

# Need to make sure ~/.vim/backup exists otherwise config causes vim to yell
[ ! -d "~/.vim/backup" ] && mkdir ~/.vim/backup

# install virtualenvwrapper if not installed
# make sure to install it to user to avoid affecting the system
pip_freeze=$(pip freeze 2> /dev/null)
[[ $pip_freeze != *"virtualenvwrapper"* ]] && pip install --user virtualenvwrapper


for file in $PWD/.*(D)
do
    cp -r $file $HOME/
done
rm -rf $HOME/.git $HOME/.gitconfig  # Remove git folders copied from repo
