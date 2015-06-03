#!/bin/env zsh

#  Vim

# Install Vundle if not already installed
[ ! -d "~/.vim/bundle/Vundle.vim" ] && git clone \
    https://github.com/gmarik/Vundle.vim.git \
    ~/.vim/bundle/Vundle.vim

# Need to make sure ~/.vim/backup exists otherwise config causes vim to yell
[ ! -d "~/.vim/backup" ] && mkdir ~/.vim/backup

for file in $PWD/.*(D)
do
    cp -r $file $HOME/
done
rm -rf $HOME/.git $HOME/.gitconfig  # Remove git folders copied from repo
