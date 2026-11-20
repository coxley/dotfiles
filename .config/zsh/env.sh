# Non-interactive environment: PATH and env vars only. For consumers that
# need the same environment as an interactive shell (nvim panes, tools
# spawned by scripts) without prompts, hooks, plugins, or completion.
# Interactive shells source these pieces via init.zsh / .zshrc instead.
source ~/.config/zsh/path.zsh
source ~/.config/zsh/env.zsh
source ~/.zsh_work

# Version-manager shims. The cached pyenv/rbenv init also sources their
# completion scripts (~140ms); PATH-only is enough here.
path=(~/.pyenv/shims ~/.rbenv/shims $path)
