[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# Motivation: https://hacdias.com/2021/05/30/cd-alias-completions-zsh/
typeset -A cd_aliases=(
    [dcd]="$HOME/Code/github.com/DataDog/dd-source/"
    [code]="$HOME/Code/"
)

for k in "${(@k)cd_aliases}"; do
    function $k() {
        cd "$cd_aliases[$0]/$1"
    }

    function _$k() {
        ((CURRENT == 2)) && _files -/ -W $cd_aliases[${0:1}]
    }

    compdef _$k $k
done

typeset -A vim_aliases=(
    [vim2]="$HOME/.config/nvim/"
)

for k in "${(@k)vim_aliases}"; do
    function $k() {
        vim "$vim_aliases[$0]/$1"
    }

    function _$k() {
        ((CURRENT == 2)) && _files -W $vim_aliases[${0:1}]
    }

    compdef _$k $k
done

