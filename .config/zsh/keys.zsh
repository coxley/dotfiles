# Emacs key bindings. Previously inherited from oh-my-zsh
# lib/key-bindings.zsh; without it main stays linked to viins, where ^P,
# ^A, ^E and friends are unbound and fall through to self-insert.
bindkey -e

# Inline up/down-arrow history cycling over atuin's full history database:
# history-search-backward semantics (prefix match, most recent first, no
# TUI, cursor left at the end of the entry) without requiring the entry to
# live in $HISTFILE. One atuin spawn on the first press of a given prefix; cycling
# after that is pure zle. Editing the line starts a new prefix search.
typeset -g _AH_ORIG _AH_LAST
typeset -gi _AH_IDX _AH_LOADED
typeset -ga _AH_MATCHES

# Invalidate the match list whenever the line editor finishes, so entries
# executed since the last fetch are picked up.
_coxley_ah_reset() { _AH_LOADED=0 }
autoload -Uz add-zle-hook-widget
add-zle-hook-widget zle-line-finish _coxley_ah_reset

_atuin-history-fetch() {
    local -a args=(--search-mode prefix --limit 500 --format '{command}' --print0)
    [[ -n $BUFFER ]] && args+=(-- $BUFFER)
    _AH_ORIG=$BUFFER
    # atuin's non-interactive output is chronological (oldest first, newest
    # last); reverse so cycling starts at the most recent match.
    _AH_MATCHES=("${(@Oa)${(@0)$(command atuin search $args 2>/dev/null)}}")
    _AH_MATCHES=("${(@)_AH_MATCHES:#}")
    _AH_IDX=0
}

_atuin-history-up() {
    if (( ! _AH_LOADED )) || [[ $BUFFER != $_AH_LAST ]]; then
        _atuin-history-fetch
        _AH_LOADED=1
        if (( $#_AH_MATCHES == 0 )); then
            _AH_LAST=$_AH_ORIG
            zle -M 'no history matches'
            return
        fi
    fi
    (( _AH_IDX < $#_AH_MATCHES )) || return
    (( _AH_IDX += 1 ))
    BUFFER=${_AH_MATCHES[_AH_IDX]}
    CURSOR=$#BUFFER
    _AH_LAST=$BUFFER
}

_atuin-history-down() {
    if (( ! _AH_IDX )); then
        zle down-line-or-history
        return
    fi
    if (( _AH_IDX == 1 )); then
        BUFFER=$_AH_ORIG
        _AH_LAST=$_AH_ORIG
        _AH_IDX=0
    else
        (( _AH_IDX -= 1 ))
        BUFFER=${_AH_MATCHES[_AH_IDX]}
        _AH_LAST=$BUFFER
    fi
    CURSOR=$#BUFFER
}

zle -N _atuin-history-up
zle -N _atuin-history-down

# Navigation and edit keys lost with oh-my-zsh lib/key-bindings.zsh.
# /etc/zshrc binds these into whichever keymap main links to at that
# moment, so after `bindkey -e` they were stranded in viins and unbound
# sequences (Delete, Home, ...) inserted literal `~` characters.
# Bind terminfo variants plus the literal forms Terminal.app sends.
for _km in emacs viins; do
    [[ -n ${terminfo[kdch1]} ]] && bindkey -M $_km ${terminfo[kdch1]} delete-char
    bindkey -M $_km '^[[3~' delete-char
    bindkey -M $_km '^[[3;5~' kill-word
    [[ -n ${terminfo[khome]} ]] && bindkey -M $_km ${terminfo[khome]} beginning-of-line
    bindkey -M $_km '^[[H' beginning-of-line
    bindkey -M $_km '^[[1~' beginning-of-line
    [[ -n ${terminfo[kend]} ]] && bindkey -M $_km ${terminfo[kend]} end-of-line
    bindkey -M $_km '^[[F' end-of-line
    bindkey -M $_km '^[[4~' end-of-line
    [[ -n ${terminfo[kich1]} ]] && bindkey -M $_km ${terminfo[kich1]} overwrite-mode
    bindkey -M $_km '^[[2~' overwrite-mode
    [[ -n ${terminfo[kpp]} ]] && bindkey -M $_km ${terminfo[kpp]} up-line-or-history
    bindkey -M $_km '^[[5~' up-line-or-history
    [[ -n ${terminfo[knp]} ]] && bindkey -M $_km ${terminfo[knp]} down-line-or-history
    bindkey -M $_km '^[[6~' down-line-or-history
    [[ -n ${terminfo[kcbt]} ]] && bindkey -M $_km ${terminfo[kcbt]} reverse-menu-complete
    bindkey -M $_km '^[[Z' reverse-menu-complete
    bindkey -M $_km '^[[1;5C' forward-word
    bindkey -M $_km '^[[1;5D' backward-word
    bindkey -M $_km '^?' backward-delete-char
done
unset _km

# Extras from the same oh-my-zsh lib.
bindkey '^X^E' edit-command-line
bindkey '^[m' copy-prev-shell-word
bindkey '^[w' kill-region
bindkey ' ' magic-space
autoload -Uz edit-command-line
bindkey -M emacs '^[[A' _atuin-history-up
bindkey -M emacs '^[OA' _atuin-history-up
bindkey -M emacs '^[[B' _atuin-history-down
bindkey -M emacs '^[OB' _atuin-history-down
bindkey -M viins '^[[A' _atuin-history-up
bindkey -M viins '^[OA' _atuin-history-up
bindkey -M viins '^[[B' _atuin-history-down
bindkey -M viins '^[OB' _atuin-history-down

# Empty WORDCHARS makes kill-word/backward-kill-word (Ctrl-W) treat all
# punctuation as separators, so Ctrl-W erases back to the last `/`.
# Side effect previously inherited from oh-my-zsh lib/completion.zsh.
WORDCHARS=''

bindkey \^U backward-kill-line
bindkey \^W backward-kill-word

# Atuin's init output is a static template per atuin version; cache it,
# and defer it past the first prompt along with the other late loads.
# Up-arrow stays on the inline cycling widget above; atuin keeps ^R.
if (( $+commands[atuin] )); then
    zsh-defer _cached_eval atuin ${commands[atuin]} atuin init zsh --disable-up-arrow
fi

function bindlist() {
  local flag_all flag_help flag_list flag_raw
  local usage=(
    "Usage:"
    "  bindlist              list bindings"
    "  bindlist -h --help    print this message"
    "Options:"
    "  -a --all              include all bindings"
    "  -l --list             single column output"
    "  -r --raw              bindkey format"
  )
  zmodload zsh/zutil
  zparseopts -D -F -- \
    {a,-all}=flag_all \
    {h,-help}=flag_help \
    {l,-list}=flag_list \
    {r,-raw}=flag_raw \
    || return 1
  [[ -z "$flag_help" ]] || { print -l $usage && return }

  local patterns _list estring
  typeset -a patterns

  if ! (( $#flag_all )); then
    patterns=(
      "\^\[\["      # match "^[["
      "\^\[O[A-H]"  # match "^[OA"..."^[OH"
      "^\"\\\M"     # match "\M-^@"-"\M-^?"
      "\"-\"~\""    # match " "-"~"
      )
    for pat in $patterns
    do
      estring=$estring" -e '"$pat"'"
    done
    _list=$(bindkey | eval grep -v $estring)
  else
    _list=$(bindkey)
  fi

  if ! (( $#flag_raw )); then
    # sed patterns
    estring=           # re-init
    patterns=(
      's/^"//g'        # remove 1st quote
      's/" / /g'       # remove 2nd quote
      's/\^\[/⌥/g'     # replace meta chars with option symbol
      's/\^\?/DEL/g'   # replace ^? with DEL
      )
    for pat in $patterns
    do
      estring=$estring" -e '"$pat"'"
    done
    _list=$(echo $_list | eval sed $estring)
  fi

  if (( $#flag_list )); then
    print -- "${_list}"
  else
    IFS=$'\n'
    print -c -- "${(f)_list}"
    unset IFS
  fi
}
compdef _gnu_generic bindlist

# https://github.com/ghostty-org/ghostty/issues/905
scroll_then_clear() { 
    printf '\033[H\033[22J'
    zle reset-prompt 
}
zle -N scroll_then_clear
bindkey '^[sclear' scroll_then_clear
bindkey '^L' scroll_then_clear
