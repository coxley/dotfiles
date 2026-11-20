# Lazy ssh-agent: adds identities on the first use of an ssh tool.
# Replaces the oh-my-zsh ssh-agent plugin; reads the same zstyle key for
# the identity list.
typeset -ga _coxley_ssh_ids=()
zstyle -a :omz:plugins:ssh-agent identities _coxley_ssh_ids

typeset -gi _COXLEY_SSH_LOADED=0
_coxley_ssh_agent_load() {
    (( _COXLEY_SSH_LOADED )) && return 0
    typeset -gi _COXLEY_SSH_LOADED=1
    # Start an agent only if the environment has none.
    [[ -n ${SSH_AUTH_SOCK:-} ]] || eval "$(ssh-agent -s)" &>/dev/null
    local id
    for id in $_coxley_ssh_ids; do
        [[ -f $HOME/.ssh/$id ]] && ssh-add "$HOME/.ssh/$id" &>/dev/null
    done
}

# Wrap the ssh tools so loading happens on first use, then pass through.
for _cmd in ssh scp sftp sshfs; do
    eval "${_cmd}() { _coxley_ssh_agent_load; command ${_cmd} \"\$@\"; }"
done
unset _cmd
