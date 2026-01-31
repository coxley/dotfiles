typeset -g PATH

local prefix=$(/opt/homebrew/bin/brew --prefix)

# Prefer GNU coreutils first
PATH="$prefix/opt/coreutils/libexec/gnubin"
PATH="$PATH:$prefix/bin"
PATH="$PATH:/usr/local/bin"
PATH="$PATH:/usr/bin"
PATH="$PATH:/bin"
PATH="$PATH:/usr/sbin"
PATH="$PATH:/sbin"

PATH="$PATH:/Users/$USER/.go/bin"
PATH="$PATH:/Users/$USER/.local/bin"
PATH="$PATH:/Users/$USER/.cargo/bin"
PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
