#!/bin/bash

#  Vim

# Install Vundle if not already installed
if [ ! -d "~/.vim/bundle/Vundle.vim" ]
then
    git clone \
        https://github.com/gmarik/Vundle.vim.git \
        ~/.vim/bundle/Vundle.vim
fi

static_files=$(find $PWD -maxdepth 1 -type f)
for file in $static_files
do
    ln -s $file $HOME/
done
rm -rf $HOME/.git $HOME/.gitconfig  # Remove git folders copied from repo
