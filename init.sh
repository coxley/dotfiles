#!/bin/env zsh

#  Vim

# Install Vundle if not already installed
if [ ! -d "~/.vim/bundle/Vundle.vim" ]
then
    git clone \
        https://github.com/gmarik/Vundle.vim.git \
        ~/.vim/bundle/Vundle.vim
fi

for file in $PWD/.*(D)
do
    cp -r $file $HOME/
done
rm -rf $HOME/.git $HOME/.gitconfig  # Remove git folders copied from repo
