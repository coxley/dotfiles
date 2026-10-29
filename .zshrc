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
    zgen oh-my-zsh plugins/catimg
    zgen oh-my-zsh plugins/common-aliases
    zgen oh-my-zsh plugins/ssh-agent

    zgen load denysdovhan/spaceship-prompt spaceship
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-completions src

    zgen save

    source ~/.config/zsh/init.zsh
    _coxley_setup
else
    source ~/.config/zsh/init.zsh
fi

# autoload -Uz /usr/share/zsh/*/functions/*(:t)
autoload -Uz /opt/homebrew/share/zsh/site-functions/*(:t)
autoload -U +X bashcompinit && bashcompinit
compinit

if [[ $ZPROF -eq 1 ]]; then
    zprof
fi

# >>> shadowfax >>>
[ -f /opt/shadowfax/shell ] && . /opt/shadowfax/shell
# <<< shadowfax <<<

# dogbrew shell-hooks: if you don't want this to be called, comment it out and dogbrew will honour that on subsequent updates.  See also the more dangerous `dogbrew self setup --disable-shell-hooks`.
[ -f "/opt/dogbrew/share/etc/dogbrew/init.zsh" ] && . "/opt/dogbrew/share/etc/dogbrew/init.zsh"
