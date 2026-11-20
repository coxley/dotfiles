# Async git status for the prompt. starship's git_status module computes
# status in-process, which costs ~0.5s in large trees like dd-source. A
# background job (forked subshell, one in flight at a time) writes the
# symbol line to a cache file; starship's custom.git_status module reads it.
# Symbols lag the worktree by about one prompt.

typeset -g _COXLEY_GST_OUT=~/.cache/zsh/git-status.zsh
typeset -g _COXLEY_GST_PID=~/.cache/zsh/git-status.pid

_coxley_git_status_hook() {
    # One refresh in flight at a time; kill -0 is a builtin, no spawn.
    local pid
    [[ -r $_COXLEY_GST_PID ]] && pid=$(<$_COXLEY_GST_PID)
    [[ -n $pid ]] && kill -0 $pid 2>/dev/null && return

    # Keep old symbols while PWD stays under the repo they describe;
    # blank them when moving somewhere else so no wrong symbols show.
    local repo
    if [[ -s $_COXLEY_GST_OUT ]] && IFS=$'\t' read -r repo _ < $_COXLEY_GST_OUT \
       && [[ $PWD == $repo/* ]]; then
        :
    else
        : >! $_COXLEY_GST_OUT
    fi

    (
        local root
        root=$(git rev-parse --show-toplevel 2>/dev/null) || {
            : >! $_COXLEY_GST_OUT
            command rm -f $_COXLEY_GST_PID
            exit 0
        }
        local -a st
        st=(${(f)"$(git status --porcelain=v1 --branch 2>/dev/null)"})

        local -i conflicted=0 deleted=0 renamed=0 modified=0 staged=0 untracked=0
        local line
        for line in ${st:1}; do
            case $line[1,2] in
                (\?\?)            (( untracked++ )) ;;
                (DD|AU|UD|UA|DU|AA|UU) (( conflicted++ )) ;;
                (*)
                    [[ $line[1] == [MDARC] ]] && (( staged++ ))
                    [[ $line[1] == R ]] && (( renamed++ ))
                    [[ $line[1] == D || $line[2] == D ]] && (( deleted++ ))
                    [[ $line[2] == M ]] && (( modified++ ))
                    ;;
            esac
        done

        local -i ahead=0 behind=0
        [[ $st[1] == *'ahead '* ]] && ahead=1
        [[ $st[1] == *'behind '* ]] && behind=1
        local -a stash_list
        stash_list=(${(f)"$(git stash list 2>/dev/null)"})

        local sym=''
        (( conflicted )) && sym+='='
        (( ahead && behind )) && sym+='⇕' || { (( ahead )) && sym+='⇡'; (( behind )) && sym+='⇣' }
        (( $#stash_list )) && sym+='$'
        (( deleted )) && sym+='✘'
        (( renamed )) && sym+='»'
        (( modified )) && sym+='!'
        (( staged )) && sym+='+'
        (( untracked )) && sym+='?'

        print -r -- "$root	$sym" >! $_COXLEY_GST_OUT
        command rm -f $_COXLEY_GST_PID
    ) &!
    print -r -- $! >! $_COXLEY_GST_PID
}
precmd_functions+=(_coxley_git_status_hook)
