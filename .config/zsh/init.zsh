source ~/.config/zsh/path.zsh
source ~/.config/zsh/env.zsh

source ~/.config/zsh/commands.zsh
source ~/.config/zsh/completion.zsh
source ~/.config/zsh/go.zsh
source ~/.config/zsh/keys.zsh
source ~/.config/zsh/setup.zsh
source ~/.config/zsh/z.sh

eval "$(/opt/homebrew/bin/brew shellenv)"

if (( $+commands[pyenv] )); then
    eval "$(pyenv init -)"
fi
if (( $+commands[rbenv] )); then
    eval "$(rbenv init -)"
fi
if (( $+commands[direnv] )); then
    eval "$(direnv hook zsh)"
fi

setopt PROMPT_SUBST
SPACESHIP_PROMPT_ORDER=(
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  venv          # virtualenv section
  terraform     # Terraform workspace section
  exec_time     # Execution time
  line_sep      # Line break
  exit_code     # Exit code section
  char          # Prompt character
)

# TODO: be smarter about available cols vs. total
_set_rprompt() {
    if [[ $(tput cols) -gt 74 ]]; then 
        SPACESHIP_RPROMPT_ORDER=(kubectl_context)
    else 
        SPACESHIP_RPROMPT_ORDER=()
    fi
}
_set_rprompt
trap '_set_rprompt' SIGWINCH

SPACESHIP_KUBECTL_CONTEXT_COLOR_GROUPS=(
  # red if namespace is "kube-system"
  red    '\(kube-system)$'

  # else, green if "qa" is anywhere in the context or namespace
  green  qa

  # else, red if context name ends with ".k8s.local" _and_ namespace is "system"
  red    '\.k8s\.local \(system)$'

  # else, yellow if "prod" is anywhere in the context or namespace
  yellow prod
)
