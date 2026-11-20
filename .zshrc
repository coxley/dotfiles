# Make it easier to profile with `ZPROF=1 zsh`
if [[ $ZPROF -eq 1 ]]; then
    zmodload zsh/zprof
fi

if [[ -f $HOME/.zsh_work ]]; then
    source $HOME/.zsh_work
fi

# Deferred loading: everything that can wait, runs after the first prompt
# renders (zsh-defer hooks precmd). The prompt (starship), PATH/env files,
# and the version-manager hooks stay immediate.
source ~/.zgen/romkatv/zsh-defer/zsh-defer.plugin.zsh

# Vendored replacements for the three oh-my-zsh plugins. The vendored
# ssh-agent is always lazy; .zsh_work sets the identities zstyle.
zsh-defer source ~/.config/zsh/plugins/common-aliases.zsh
zsh-defer source ~/.config/zsh/plugins/catimg.zsh
zsh-defer source ~/.config/zsh/plugins/ssh-agent.zsh

# Highlighting, completions file, and zsh-completions fpath. zgen is
# retired as a manager; ~/.zgen stays as the clone cache.
zsh-defer source ~/.zgen/zsh-users/zsh-syntax-highlighting-master/zsh-syntax-highlighting.zsh
zsh-defer source ~/.config/zsh/completion.zsh
fpath=(~/.zgen/zsh-users/zsh-completions-master/src $fpath)

# compdef calls run before compinit below; buffer and replay after it. The
# stub stays active until the deferred compinit replaces it.
typeset -ga _coxley_compdefs
compdef() { _coxley_compdefs+=("${(F)argv}") }

source ~/.config/zsh/init.zsh

# Single compinit, deferred until after the first prompt. Full run when the
# dump is missing or older than 24 hours; -C skips the audit and dump
# rewrite otherwise. brew's site-functions are in fpath already.
_coxley_compinit() {
    unset -f compdef
    autoload -Uz compinit
    # Glob qualifiers do not expand inside [[ ]]; collect via array assignment.
    local -a _dumps=( ${ZDOTDIR:-$HOME}/.zcompdump(.Nmh+24) )
    if [[ ! -f ${ZDOTDIR:-$HOME}/.zcompdump ]] || (( ${#_dumps} )); then
        compinit
    else
        compinit -C
    fi

    # Replay compdef calls buffered while init files loaded. Each entry
    # holds one call with its arguments newline-joined.
    local _c
    for _c in "${_coxley_compdefs[@]}"; do
        compdef ${(f)_c}
    done
    unset _c

    autoload -U +X bashcompinit && bashcompinit
}
zsh-defer _coxley_compinit

if [[ $ZPROF -eq 1 ]]; then
    zprof
fi

# >>> shadowfax >>>
[ -f /opt/shadowfax/shell ] && . /opt/shadowfax/shell
# <<< shadowfax <<<

# dogbrew shell-hooks: if you don't want this to be called, comment it out and dogbrew will honour that on subsequent updates.  See also the more dangerous `dogbrew self setup --disable-shell-hooks`.
[ -f "/opt/dogbrew/share/etc/dogbrew/init.zsh" ] && . "/opt/dogbrew/share/etc/dogbrew/init.zsh"

if [[ $REX_BLOCK ]]; then 
    block_label=$(rex block inspect $REX_BLOCK --json | jq -r '.block.label')
    # Avoid setting every pane to 'shell' since that's a common default
    if [[ $block_label != "shell" ]]; then
        echo -ne "\e]0;$block_label\a"
    fi
fi
