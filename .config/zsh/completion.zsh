[[ $commands[kubectl] ]] && source <(kubectl completion zsh)
# Motivation: https://hacdias.com/2021/05/30/cd-alias-completions-zsh/
typeset -A cd_aliases=(
    [dcd]="$HOME/Code/github.com/DataDog/dd-source"
    [gcd]="$HOME/Code/github.com/DataDog/dd-go"
    [ecd]="$HOME/Code/github.com/DataDog/experimental/users"
    [ucd]="$HOME/Code/github.com/DataDog/dd-source/domains/unifiedkv"
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
    # Load git-dd completions for zsh
    autoload -Uz _git_dd

    # This way the completion script does not have to parse Bazel's options
    # repeatedly.  The directory in cache-path must be created manually.
    # zstyle ':completion:*' use-cache on
    # zstyle ':completion:*' cache-path ~/.zsh/cache
    compdef _bazel bzl
fi
