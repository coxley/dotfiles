# Make it easier to profile with `ZPROF=1 zsh`
if [[ $ZPROF -eq 1 ]]; then
    zmodload zsh/zprof
fi

if [[ -f $HOME/.zsh_work ]]; then
    source $HOME/.zsh_work
fi

source ~/.config/zsh/zgen.zsh
if ! zgen-saved; then
    echo "Creating a zgen save"

    zgen oh-my-zsh
    zgen load denysdovhan/spaceship-prompt spaceship
    zgen load zsh-users/zsh-syntax-highlighting

    zgen oh-my-zsh plugins/catimg
    zgen oh-my-zsh plugins/common-aliases
    zgen oh-my-zsh plugins/ssh-agent

    zgen save

    source ~/.config/zsh/init.zsh
    _coxley_setup
else
    source ~/.config/zsh/init.zsh
fi


if [[ $ZPROF -eq 1 ]]; then
    zprof
fi
