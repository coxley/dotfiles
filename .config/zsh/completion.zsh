# Do menu-driven completion.
zstyle ':completion:*' menu select

# Completion behavior from oh-my-zsh lib/completion.zsh: fuzzy substring
# matching (r:|=* makes .proto match admin.proto), menu on successive TAB,
# in-word completion, cursor to end after completion.
unsetopt menu_complete
setopt auto_menu complete_in_word always_to_end
unsetopt flowcontrol
zmodload -i zsh/complist
bindkey -M menuselect '^o' accept-and-infer-next-history
if [[ $CASE_SENSITIVE = true ]]; then
    zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'
else
    zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|=*' 'l:|=* r:|=*'
fi
zstyle ':completion:*' special-dirs true
zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh

# match uppercase from lowercase
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
 
# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Color completion for some things.
# http://linuxshellaccount.blogspot.com/2008/12/color-completion-using-zsh-modules-on.html
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# formatting and messages
# http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
# zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format "$fg[yellow]%B--- %d%b"
zstyle ':completion:*:messages' format '%d'
# zstyle ':completion:*:warnings' format "$fg[red]No matches for:$reset_color %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
# zstyle ':completion:*' group-name ''

if [[ $commands[kubectl] ]]; then
    _cached_eval kubectl ${commands[kubectl]} kubectl completion zsh
fi
# Motivation: https://hacdias.com/2021/05/30/cd-alias-completions-zsh/
typeset -A cd_aliases=(
    [dcd]="$HOME/Code/github.com/DataDog/dd-source"
    [gcd]="$HOME/Code/github.com/DataDog/dd-go"
    [ecd]="$HOME/Code/github.com/DataDog/experimental/users"
    [ucd]="$HOME/Code/github.com/DataDog/dd-source/domains/unifiedkv"
    [dog]="$HOME/Code/github.com/DataDog"
    [code]="$HOME/Code"
)

for key in "${(@k)cd_aliases}"; do
    function $key() {
        local dst="$cd_aliases[$0]/$1"
        local repo_path=$(dirname $(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) 2>/dev/null)

        # If destination is a child of the current repo, stay within the active
        # worktree.
        if [[ $repo_path != "" && $dst == "$repo_path"/* ]]; then
            worktree_path=$(git rev-parse --show-toplevel)
            cd $worktree_path/${dst#$repo_path}
        else
            cd $dst
        fi
    }

    function _$key() {
        ((CURRENT == 2)) && {
            local dst="$cd_aliases[${0:1}]/"
            local repo_path=$(dirname $(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null) 2>/dev/null)

            # If destination is a child of the current repo, stay within the active
            # worktree.
            if [[ $repo_path != "" && $dst == "$repo_path"/* ]]; then
                worktree_path=$(git rev-parse --show-toplevel)
                _files -/ -W $worktree_path/${dst#$repo_path}/
            else
                _files -/ -W $dst
            fi
        }
    }

    compdef _$key $key
done

typeset -A vim_aliases=(
    [vim2]="$HOME/.config/nvim/"
)

for key in "${(@k)vim_aliases}"; do
    function $key() {
        vim "$vim_aliases[$0]/$1"
    }

    function _$key() {
        ((CURRENT == 2)) && _files -W $vim_aliases[${0:1}]
    }

    compdef _$key $key
done

if (( ${+DATADOG_ROOT} )); then
    compdef _bazel bzl

    [[ -d ~/.cache/zsh ]] || mkdir -p ~/.cache/zsh
    zstyle ':completion:*' use-cache on
    zstyle ':completion:*' cache-path ~/.cache/zsh/cache
fi

function w() {
    if [[ -z $1 ]]; then
        git worktree list
        return
    fi
    git worktree $*
}

# Complete git from zsh's native _git rather than brew's bash-completion
# bridge: only the native version defines the _git-* subcommand functions,
# including _git-worktree for the `w` wrapper below. Direct sourcing
# parses with user options and fails, so load it via autoload from the
# system functions dir.
_fpath=($fpath)
fpath=(/usr/share/zsh/5.9/functions $fpath)
autoload -Uz +X _git
fpath=($_fpath)
unset _fpath

# Executing _git defines its subcommand functions, but that costs over
# 100ms, so run it on the first completion of `w` instead of at startup.
# The anonymous function keeps the bootstrap's service/CURRENT overrides
# from leaking into _git-worktree's completion state.
_w() {
    if (( ! $+functions[_git-worktree] )); then
        () {
            local service=__w_bootstrap CURRENT=1
            _git &>/dev/null
        }
    fi
    _git-worktree "$@"
}
compdef _w w

function wcd() {
    repo_path=$(dirname $(git rev-parse --path-format=absolute --git-common-dir))
    repo_name=$(basename $repo_path)
    owner_path=$(dirname $repo_path)
    worktree_path=$owner_path/worktrees/$repo_name

    relative_pwd=${PWD#"$(git rev-parse --show-toplevel)"}

    if [[ $1 == "default" ]]; then
        cd $repo_path/$relative_pwd || cd $repo_path 2>/dev/null
    elif [[ $1 == "" ]]; then
        cd $repo_path/$relative_pwd || cd $repo_path 2>/dev/null
    else
        cd $worktree_path-$1/$relative_pwd || cd $worktree_path-$1 2>/dev/null
    fi
}

# TODO: Refactor all custom functions and completions into site-functions
function _wcd() {
    # Only render for the first positional arg
    _arguments -C '1: :->cmds' '*:: :->args'

    case "$state" in
        (cmds)
            repo_path=$(dirname $(git rev-parse --path-format=absolute --git-common-dir))
            repo_name=$(basename $repo_path)
            owner_path=$(dirname $repo_path)
            worktree_path=$owner_path/worktrees/$repo_name

            local -a _values

            for entry in ${(ps:\n:)"$(git worktree list --no-porcelain)"}; do 
                entry=${entry#"$worktree_path-"}
                read -rA parts <<< $entry

                if [[ $parts[1] == $repo_path ]]; then
                    parts[1]="default"
                fi
                _values+=("$parts[1]:$parts[3,-1]")
            done
            _describe -V 'workspaces' _values
        ;;
    esac
}

compdef _wcd wcd

function wadd() {
    repo_path=$(dirname $(git rev-parse --path-format=absolute --git-common-dir))
    repo_name=$(basename $repo_path)
    owner_path=$(dirname $repo_path)
    worktree_path=$owner_path/worktrees/$repo_name

    mkdir -p $owner_path/worktrees
    git worktree add --no-detach $worktree_path-$1 origin/main
}

compdef kubecolor=kubectl
