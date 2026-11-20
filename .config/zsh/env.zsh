function _set_default() {
    local name=$1
    if [[ ${(P)name} ]]; then
        return
    else
        typeset -g "$name=$2"
    fi
}

# History. The long-term store is atuin's database; .zsh_history is a
# recent cache. Huge sizes made every shell load the whole file and
# triggered full-file rewrites on exit — the main corruption source.
export HISTSIZE=100000
export SAVEHIST=100000
export HISTORY_IGNORE="(history|ls|exit|ll|*clear) *"

setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY             # Share history between all sessions; implies incremental appends.
setopt HIST_FCNTLLOCK            # fcntl locks for concurrent writers, not lock files.
setopt HIST_NO_FUNCTIONS         # Don't store function definitions; their multiline entries corrupt easily.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_NO_STORE             # Don't store history commands
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks from each command line being added to the history.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.

CASE_SENSITIVE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

if [[ $REX_SESSION ]]; then
    export TERM=xterm-rex
fi
_set_default TERM xterm-256color
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# FZF
export FZF_DEFAULT_COMMAND='rg -g ""'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='
 --color=fg:242,bg:236,hl:65,fg+:15,bg+:239,hl+:108
 --color=info:108,prompt:109,spinner:108,pointer:168,marker:168
'

# Editor preferences
# Prefer neovim when available
if hash nvim 2> /dev/null; then
    alias vim='nvim'
    export EDITOR=nvim
    export KUBE_EDITOR=nvim
else
    export EDITOR=vim
    export KUBE_EDITOR=vim
fi

export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export GPG_TTY=$TTY
export BAT_THEME=ansi

# Force certain more-secure behaviours from homebrew
export HOMEBREW_NO_INSECURE_REDIRECT=1
export HOMEBREW_CASK_OPTS=--require-sha
export HOMEBREW_DIR=/opt/homebrew
export HOMEBREW_BIN=/opt/homebrew/bin

export STARSHIP_LOG=error
export SHADOWFAX_ALIAS_NOTICE=0
