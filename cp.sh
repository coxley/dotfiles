#!/bin/bash

# install virtualenvwrapper if not installed
# make sure to install it to user to avoid affecting the system
pip_freeze=$(pip freeze 2> /dev/null)
[[ $pip_freeze != *"virtualenvwrapper"* ]] && pip install --user virtualenvwrapper


static_files=$(find $PWD -maxdepth 1 -type f)
for file in $static_files
do
    cp -r $file $HOME/
done
rm -rf $HOME/.git $HOME/.gitconfig  # Remove git folders copied from repo
