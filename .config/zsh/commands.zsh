# Global alias for things like 'some-cmd NUL'
alias -g NUL=' &> /dev/null'

# 'vim tt' -> 'vim <temp>.sh' for quick testing
alias -g tt='$(mktemp --suffix=.sh)'

# Create random temp directory that will be cleaned up by the OS later, and cd into it
alias tmp='cd $(mktemp -d)'

# Sort IPv4 addresses
alias sortip='sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n'

# View profile in the browser
alias pprof_http='go tool pprof -http localhost:$(random_port)'

alias ga='git add -A'
alias gs='git status'
alias gc='git checkout'
alias gl='git log'
alias rg='rg --no-heading'
alias kns='kubens'
alias ktx='kubectx'

alias paths='echo -e ${PATH//:/\\n}'
alias alias_names="alias | sed 's/=.*//'"
alias function_names="declare -f | grep '^[a-z].* ()' | sed 's/{$//'"

alias ungron="gron --ungron"
alias sql=sleek
alias ls='eza --group-directories-first -X'
alias ll='ls -l'
alias lls='ll --total-size'
alias tree='eza -T'

# Generated random port for things that don't support :0
function random_port() {
  while true; do
    port=$(( 49152 + RANDOM % (65536 - 49152) ))
    if ! nc -z localhost "$port" 2>/dev/null; then
      echo "$port"
      return
    fi
  done
}

# With colors
function man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

function fd() {
    find . -iname "*$1*" 2>/dev/null
}

# Print where each standard stream is pointed to
function streams() {
    lsof -a -d 0-2 -F pfn -p $$ | awk '
        /^p/ { pid = substr($0, 2) }
        /^f/ { fd  = substr($0, 2) }
        /^n/ { name = substr($0, 2); print pid, fd, name }
    '
}

# Print current k8s context details
function kc() {
    cat <<EOF
CONTEXT: $(kubectx -c)
NAMESPACE: $(kubens -c)
EOF
}

# nvm shit is slow, so defer until needed.
function init_nvm() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

# Scaffold the local directory with a scratch go project for tests
function mkgo() {
    go mod init ${1:-scratch}
    cat <<EOF > main.go
package main

func main() {
}

func must(err error) {
	if err != nil {
		panic(err)
	}
}

func must2[T any](v T, err error) T {
	if err != nil {
		panic(err)
	}
	return v
}
EOF
    cat <<EOF > main_test.go
package main

import (
	"testing"
	"github.com/stretchr/testify/require"
)

func Test(t *testing.T) {
    require.True(t, true)
}

func Benchmark(b *testing.B) {
    for b.Loop() {
    }
}
EOF
    go mod tidy
}

function scratch() {
    cd $(mktemp -d)
    mkgo
}

# Run a local GCS emulator and put files into tmp dir
function gcsemu() {
    # Install the gcsemulator if it's not existent
    if ! (( $+commands[gcsemulator] )); then
        go install github.com/fullstorydev/emulators/storage/cmd/gcsemulator@latest
    fi
    t=$(mktemp -d)
    cd ${t} && echo "storing results to ${t}"
    gcsemulator -port 9000 -dir .
}

# Store each pattern into a file for vim to be aware of
function rg() {
    FORWARD=()
    while getopts ":-:" opt; do
        case $opt in
        -)
            FORWARD+=("--${OPTARG}")
            ;;
        \?)
            FORWARD+=("-${OPTARG}")
            ;;
        esac
    done

    shift $(($OPTIND - 1))

    PATTERN=$1
    shift

    for arg in $*; do
        FORWARD+=($arg)
    done

    command rg ${PATTERN} ${FORWARD}
    exit_code=$?
    echo -n ${PATTERN} > ~/.local/share/last-search
    return $exit_code
}


# Search, ignoring vendored directories
function rgv() {
    FORWARD=()
    while getopts ":-:" opt; do
        case $opt in
        -)
            FORWARD+=("--${OPTARG}")
            ;;
        \?)
            FORWARD+=("-${OPTARG}")
            ;;
        esac
    done
    shift $(($OPTIND - 1))
    for arg in $*; do
        FORWARD+=($arg)
    done

    command rg --no-heading -g '!vendor' ${FORWARD}
    return $?
}

function gcp-spot-pods() {
    nodes=$(kubectl get nodes ${@} -o json | jq '
    [
        .items.[]
        | {"key": .metadata.name, "value": ([.metadata.labels["cloud.google.com/gke-spot"]] | all)}
    ]
    | from_entries
    ')
    pods=$(kubectl get pods ${@} -o json | jq '[
      .items.[] 
      | {"name": .metadata.name, "node": .spec.nodeName}
    ]')
    echo $nodes $pods | jq -s '
      .[0] as $nodes 
      | .[1] as $pods 
      | $pods.[] 
      | {"pod": .name, "node": .node, "spot": $nodes[.node]}
    '
}

function aerofloat() {
    app_id=$(osascript -e "id of app \"$1\"") || return 1
    cat <<EOF >> ~/.config/aerospace/aerospace.toml

[[on-window-detected]]
    if.app-id = '${app_id}'
    run = 'layout floating'
EOF
    aerospace reload-config
}

function toggle_aerospace_preset() {
    tmpfile=$(mktemp)
    aerospace_cfg=$(aerospace config --config-path)
    current=$(toml get --raw $aerospace_cfg key-mapping.preset)
    case $current in
        qwerty)
            toml set $aerospace_cfg key-mapping.preset dvorak > $tmpfile
            ;;
        dvorak)
            toml set $aerospace_cfg key-mapping.preset qwerty > $tmpfile
            ;;
        *)
            echo "unexpected preset '$current'"
            return 1
            ;;
    esac

    mv -f $tmpfile $aerospace_cfg
    aerospace reload-config
}

function render() {
    # curl -L -o lightpanda https://github.com/lightpanda-io/browser/releases/download/nightly/lightpanda-aarch64-macos && chmod a+x ./lightpanda
    # mv lightpanda .local/bin
    # pip3 install 'markitdown[all]'
    lightpanda fetch --dump --log_level error $1 | markitdown | glow
}

function clone() {
    parsed=$(urlparse -host -path $1)
    host=$(echo $parsed | cut -f1)
    location=$(echo $parsed | cut -f2 | sed 's#^/##g')
    if [[ -z $host ]]; then
        host="github.com"
    fi

    dir=~/Code/${host}/${location}
    mkdir -p $dir

    case $host in
        github.com)
            gh repo clone $location $dir
            ;;
        *)
            git clone $1 $dir
            ;;
    esac

    cd $dir
}
