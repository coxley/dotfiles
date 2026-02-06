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
    compdef _bazel bzl

    mkdir -p ~/.cache/zsh
    zstyle ':completion:*' use-cache on
    zstyle ':completion:*' cache-path ~/.cache/zsh/cache
fi
