typeset -g PATH
typeset -U path

# /opt/homebrew is brew's fixed prefix on Apple Silicon; Intel falls back.
local prefix=/opt/homebrew
[[ -d $prefix ]] || prefix=/usr/local
local inherited=$PATH

# Prefer GNU coreutils first
PATH="$prefix/opt/coreutils/libexec/gnubin"
PATH="$PATH:$prefix/bin"
PATH="$PATH:$prefix/opt/rustup/bin" # keg-only; rustc/cargo/rust-analyzer proxies
PATH="$PATH:/usr/local/bin"
PATH="$PATH:/usr/bin"
PATH="$PATH:/bin"
PATH="$PATH:/usr/sbin"
PATH="$PATH:/sbin"

PATH="$PATH:$HOME/.go/bin"
PATH="$PATH:$HOME/.local/bin"
PATH="$PATH:$HOME/.cargo/bin"
PATH="$PATH:$HOME/.hunk/bin"
PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
PATH="$PATH:/Applications/Obsidian.app/Contents/MacOS"
PATH="$PATH:/opt/dogbrew/bin"
PATH="$PATH:$HOME/dd/devtools/bin"

# Linux workspaces set tool dirs (python, dogbrew shims, multiplexer shims)
# in the login PATH; keep them ahead of the list above.
[[ $OSTYPE == linux* ]] && PATH="$inherited:$PATH"
# rustup's proxies must beat the image's /usr/bin/cargo (too old for dd-source).
[[ $OSTYPE == linux* ]] && PATH="$HOME/.cargo/bin:$PATH"

if [ -n "${REX_BIN_DIR:-}" ]; then
    export PATH="$REX_BIN_DIR:$PATH"
fi
