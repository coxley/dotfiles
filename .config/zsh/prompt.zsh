# Starship's PROMPT uses $(...) command substitution at render time.
setopt PROMPT_SUBST

# Workspace ssh-agent indicator and repair. The workspace links
# ~/.ssh/ssh_auth_sock to the newest forwarded agent, which dies with its ssh
# session; ws-tunnels on the Mac keeps one at a fixed path. A dead socket
# falls back to that one. zsocket connects without spawning a process;
# starship's env_var modules show green or red from whichever variable is
# exported.
if [[ $OSTYPE == linux* ]] && zmodload zsh/net/socket 2>/dev/null; then
    typeset -g _coxley_agent_rex=/tmp/ssh-rexagent/agent.rex
    _coxley_agent_hook() {
        unset _COXLEY_AGENT_OK _COXLEY_AGENT_DOWN
        local sock
        for sock in $SSH_AUTH_SOCK $_coxley_agent_rex; do
            if [[ -n $sock ]] && zsocket $sock 2>/dev/null; then
                exec {REPLY}>&-
                export SSH_AUTH_SOCK=$sock _COXLEY_AGENT_OK=1
                return
            fi
        done
        export _COXLEY_AGENT_DOWN=1
    }
    precmd_functions+=(_coxley_agent_hook)
fi

# Starship prompt. Its init output is a static template per starship
# version, so cache it like the other init hooks.
if (( $+commands[starship] )); then
    _cached_eval starship ${commands[starship]} starship init zsh
fi
