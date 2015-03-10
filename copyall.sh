#!/bin/env zsh

for file in $PWD/*(D).
do
    cp -r $file $HOME/
done
