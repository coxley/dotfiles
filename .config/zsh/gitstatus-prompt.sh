#!/bin/sh
# Reads the git-status cache written by gitstatus.zsh and prints the symbol
# line when the current directory is inside the cached repo.
f="${HOME}/.cache/zsh/git-status.zsh"
[ -s "$f" ] || exit 0
read -r repo syms < "$f" || exit 0
case "$PWD/" in
    "$repo"/*) printf '%s' "$syms" ;;
esac
