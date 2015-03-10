#!/bin/bash

static_files=$(find $PWD -maxdepth 1 -type f)
for file in $static_files
do
    ln -s $file $HOME/
done
