# Source ~/.cache/zsh/<name>.zsh, regenerated when the generator binary is
# newer than the cache. Replaces one process spawn per shell with a file
# read for init hooks and completion scripts. Callers pass the binary via
# ${commands[...]} — no subshell fork, no whence spawn.
_cached_eval() {
    local name=$1 gen=$2
    shift 2
    local out=~/.cache/zsh/$name.zsh
    [[ -d $out:h ]] || mkdir -p $out:h
    if [[ ! -f $out ]] || [[ $gen -nt $out ]]; then
        "$@" >! $out
    fi
    source $out
}

source ~/.config/zsh/path.zsh
source ~/.config/zsh/env.zsh

source ~/.config/zsh/commands.zsh
source ~/.config/zsh/completion.zsh
source ~/.config/zsh/go.zsh
source ~/.config/zsh/keys.zsh
source ~/.config/zsh/setup.zsh
source ~/.config/zsh/z.sh
source ~/.config/zsh/gitstatus.zsh
source ~/.config/zsh/prompt.zsh

if [[ -x /opt/homebrew/bin/brew ]]; then
    _cached_eval brew /opt/homebrew/bin/brew /opt/homebrew/bin/brew shellenv
fi

# pyenv init emits `pyenv rehash` (100ms) and a bash PATH scrub on every
# source. Cache the static parts, scrub shims natively, and rehash only
# when the installed versions changed.
if (( $+commands[pyenv] )); then
    _pyenv=~/.cache/zsh/pyenv.zsh
    [[ -d ~/.cache/zsh ]] || mkdir -p ~/.cache/zsh
    if [[ ! -f $_pyenv ]] || [[ ${commands[pyenv]} -nt $_pyenv ]]; then
        pyenv init - \
            | sed -E -e '/^PATH="\$\(bash/,/\)"$/d' -e '/^command pyenv rehash$/d' \
            >! $_pyenv
    fi
    path=("${(@)path:#${PYENV_ROOT:-$HOME/.pyenv}/shims}")
    source $_pyenv
    if [[ ! -f ~/.cache/zsh/pyenv-rehash-stamp ]] \
       || [[ ${PYENV_ROOT:-$HOME/.pyenv}/versions -nt ~/.cache/zsh/pyenv-rehash-stamp ]]; then
        command pyenv rehash
        touch ~/.cache/zsh/pyenv-rehash-stamp
    fi
    unset _pyenv
fi
# Same treatment for rbenv.
if (( $+commands[rbenv] )); then
    _rbenv=~/.cache/zsh/rbenv.zsh
    if [[ ! -f $_rbenv ]] || [[ ${commands[rbenv]} -nt $_rbenv ]]; then
        rbenv init - | sed -E '/^command rbenv rehash$/d' >! $_rbenv
    fi
    path=("${(@)path:#${RBENV_ROOT:-$HOME/.rbenv}/shims}")
    source $_rbenv
    if [[ ! -f ~/.cache/zsh/rbenv-rehash-stamp ]] \
       || [[ ${RBENV_ROOT:-$HOME/.rbenv}/versions -nt ~/.cache/zsh/rbenv-rehash-stamp ]]; then
        command rbenv rehash
        touch ~/.cache/zsh/rbenv-rehash-stamp
    fi
    unset _rbenv
fi
if (( $+commands[direnv] )); then
    _cached_eval direnv ${commands[direnv]} direnv hook zsh
fi

# lspmux shares rust-analyzer across nvim instances (nvim lsp.lua). macOS runs the
# server from launchd; Linux workspaces have no user systemd, so start it here.
if [[ $OSTYPE == linux* ]] && (( $+commands[lspmux] )) && ! lspmux status &>/dev/null; then
    [[ -d ~/.local/state ]] || mkdir -p ~/.local/state
    lspmux server &>>~/.local/state/lspmux.log &!
fi
