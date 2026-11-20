#!/usr/bin/env bash
# Set up these dotfiles on an x86_64 Ubuntu workspace. Run from the repo
# root. Re-runnable: installed tools and existing clones are skipped.
set -euo pipefail

bin=~/.local/bin
mkdir -p "$bin" ~/.config ~/.local/share

# Mirror the macOS layout. The repos stay in ~/go/src/github.com/DataDog:
# ~/go is on the persistent disk (the rest of ~ is the container overlay),
# and the workspace's DATADOG_ROOT points there.
mkdir -p ~/Code/github.com ~/.go/src/github.com
ln -sfn ~/go/src/github.com/DataDog ~/Code/github.com/DataDog
ln -sfn ~/Code/github.com/DataDog ~/.go/src/github.com/DataDog
ln -sfn ~/.go/src/github.com/DataDog ~/dd

# fetch <repo> <asset> <binary>: install <binary> from the latest GitHub
# release. {v} in <asset> expands to the version without the leading v.
fetch() {
    command -v "$3" >/dev/null && return
    local tag tmp
    tag=$(curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$1/releases/latest")
    tag=${tag##*/}
    tmp=$(mktemp -d)
    curl -fsSL "https://github.com/$1/releases/download/$tag/${2//\{v\}/${tag#v}}" -o "$tmp/asset"
    case $2 in
        *.tar.gz) tar -xzf "$tmp/asset" -C "$tmp" ;;
        *.gz) gunzip -c "$tmp/asset" >"$tmp/$3" ;;
        *) mv "$tmp/asset" "$tmp/$3" ;;
    esac
    install -m 755 "$(find "$tmp" -type f -name "$3" | head -1)" "$bin/$3"
    rm -rf "$tmp"
}

clone() { [[ -d $2 ]] || git clone --depth 1 "https://github.com/$1" "$2"; }

# image.nvim builds the magick rock against ImageMagick.
dpkg -s libmagickwand-dev &>/dev/null || {
    sudo apt-get update
    sudo apt-get install -y libmagickwand-dev
}

if ! command -v nvim >/dev/null; then
    curl -fsSL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz | tar -xz -C ~/.local
    ln -sfn ~/.local/nvim-linux-x86_64/bin/nvim "$bin/nvim"
fi
fetch starship/starship starship-x86_64-unknown-linux-musl.tar.gz starship
fetch atuinsh/atuin atuin-x86_64-unknown-linux-musl.tar.gz atuin
fetch eza-community/eza eza_x86_64-unknown-linux-musl.tar.gz eza
fetch kubecolor/kubecolor 'kubecolor_{v}_linux_amd64.tar.gz' kubecolor
fetch mikefarah/yq yq_linux_amd64 yq
fetch tree-sitter/tree-sitter tree-sitter-linux-x64.gz tree-sitter
fetch rtk-ai/rtk rtk-x86_64-unknown-linux-musl.tar.gz rtk
fetch mvdan/gofumpt 'gofumpt_v{v}_linux_amd64' gofumpt
# git's pager, diff and merge tools (.config/git/config).
fetch dandavison/delta 'delta-{v}-x86_64-unknown-linux-musl.tar.gz' delta
fetch Wilfred/difftastic 'difft-{v}-x86_64-unknown-linux-musl.tar.gz' difft

# .zshrc sources these from the old zgen clone layout.
clone romkatv/zsh-defer ~/.zgen/romkatv/zsh-defer
clone zsh-users/zsh-syntax-highlighting ~/.zgen/zsh-users/zsh-syntax-highlighting-master
clone zsh-users/zsh-completions ~/.zgen/zsh-users/zsh-completions-master

[[ -f ~/.zshrc && ! -L ~/.zshrc ]] && mv ~/.zshrc ~/.zshrc.pre-dotfiles
ln -sfn "$PWD/.zshrc" ~/.zshrc
for d in atuin git nvim rumdl zsh; do
    ln -sfn "$PWD/.config/$d" ~/.config/$d
done

# Rust: rustup, since dd-source pins a toolchain and the image's cargo is too old.
# Each toolchain gets rust-analyzer and rust-src; nvim's lsp.lua also needs lspmux
# and cargo-subspace, and git's merge driver is mergiraf. lspmux reads
# ~/.config/lspmux on Linux.
[[ -x ~/.cargo/bin/rustup ]] || curl -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path
pin=$(sed -n 's/^channel = "\(.*\)"/\1/p' ~/dd/dd-source/rust-toolchain.toml 2>/dev/null || true)
for tc in stable $pin; do
    ~/.cargo/bin/rustup toolchain install "$tc" --component rust-analyzer,rust-src
done
for c in lspmux cargo-subspace mergiraf; do
    [[ -x ~/.cargo/bin/$c ]] || ~/.cargo/bin/cargo install --locked "$c"
done
ln -sfn "$PWD/Library/Application Support/lspmux" ~/.config/lspmux

[[ -f ~/.local/share/atuin/history.db ]] || "$bin/atuin" import zsh
"$bin/nvim" --headless '+Lazy! sync' +qa
