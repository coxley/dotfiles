#!/bin/env zsh

for file in $PWD/.*(D)
do
    cp -r $file $HOME/
done

ZSH=$HOME/.oh-my-zsh
# Install ohmyzsh if not already installed
if [ ! -d "$ZSH" ]
then
    curl -L \
        https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh \
        | sh
fi

# Install Vundle if not already installed
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]
then
    git clone \
        https://github.com/gmarik/Vundle.vim.git \
        $HOME/.vim/bundle/Vundle.vim
fi

