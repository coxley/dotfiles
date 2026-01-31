source ~/.config/zsh/path.zsh
source ~/.config/zsh/env.zsh

source ~/.config/zsh/commands.zsh
source ~/.config/zsh/completion.zsh
source ~/.config/zsh/go.zsh
source ~/.config/zsh/keys.zsh
source ~/.config/zsh/setup.zsh
source ~/.config/zsh/z.sh

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

SPACESHIP_RPROMPT_ORDER=(kubectl_context)

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

autoload -U +X bashcompinit && bashcompinit
# autoload -Uz compinit
# compinit
