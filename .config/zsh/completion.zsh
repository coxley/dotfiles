# Do menu-driven completion.
zstyle ':completion:*' menu select

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

[[ $commands[kubectl] ]] && source <(kubectl completion zsh)
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
        cd "$cd_aliases[$0]/$1"
    }

    function _$key() {
        ((CURRENT == 2)) && _files -/ -W "$cd_aliases[${0:1}]/"
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

    mkdir -p ~/.cache/zsh
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

(( $+functions[_git-worktree] )) || _git &>/dev/null
compdef _git-worktree w

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
