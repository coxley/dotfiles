export ZSH=$HOME/.oh-my-zsh

# Install ohmyzsh if not already installed
if [ ! -d "$ZSH" ]
then
    curl -L \
        https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh \
        | sh
fi

# Install Vundle if not already installed
if [ ! -d "$HOME/.vim/bundle/Vundle.vim" ]
then
    git clone \
        https://github.com/gmarik/Vundle.vim.git \
        $HOME/.vim/bundle/Vundle.vim
fi

ZSH_THEME="steeef"
#ZSH_THEME="bira"
#ZSH_THEME="tjkirch"

CASE_SENSITIVE="true"
HIST_STAMPS="yyyy-mm-dd"
HISTFILE=~/.zsh_history
UPDATE_ZSH_DAYS=15
DISABLE_UNTRACKED_FILES_DIRTY="true"

plugins=(git 
         vim 
         catimg 
         common-aliases 
         jsontools 
         pip 
         python 
         rand-quote 
         sprunge 
         sudo 
         systemd 
         tmux 
         urltools 
         web-search 
         wd 
         zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source $HOME/.aliases
source $HOME/.functions

# virtualenvwrapper
export WORKON_HOME=$HOME/docs/envs
export PROJECT_HOME=$HOME/docs/projects
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python2.7 
source /usr/bin/virtualenvwrapper.sh
# Most environment set in .zshenv
[ -n "$TMUX" ] && export TERM=screen-256color

bindkey \^U backward-kill-line
stty icrnl
