# Starship's PROMPT uses $(...) command substitution at render time.
setopt PROMPT_SUBST

# Workspace ssh-agent indicator and repair. ws-tunnels on the Mac forwards the
# Mac's launchd agent, which has the work and ddoghq keys, to a fixed path; prefer it. The
# workspace's ~/.ssh/ssh_auth_sock follows the newest ssh login instead, whose
# agent can hold fewer keys or die with that session, so it is only the
# fallback. zsocket connects without spawning a process; starship's env_var
# modules show green or red from whichever variable is exported.
if [[ $OSTYPE == linux* ]] && zmodload zsh/net/socket 2>/dev/null; then
    typeset -g _coxley_agent_rex=/tmp/ssh-rexagent/agent.rex
    _coxley_agent_hook() {
        unset _COXLEY_AGENT_OK _COXLEY_AGENT_DOWN
        local sock
        for sock in $_coxley_agent_rex $SSH_AUTH_SOCK; do
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
