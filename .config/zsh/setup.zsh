function _coxley_setup() {
    _coxley_ensure_tools
}

function _coxley_ensure_tools() {
    # Install if missing
    typeset -A ENSURE_TOOLS_GO=(
        [gron]=github.com/tomnomnom/gron@latest
        [urlparse]=github.com/rsdoiel/urlparse/cmds/urlparse@latest
        [svu]=github.com/caarlos0/svu@latest
    )
    for key value in ${(kv)ENSURE_TOOLS_GO}; do
        if ! (( $+commands[$key] )); then
            go install $value
        fi
    done

    typeset -A ENSURE_TOOLS_RS=(
        [sleek]=sleek
        [toml]=toml-cli
        [uuid]=uuid-v4-cli
        [rumdl]=rumdl
        [eza]=eza
    )
    for key value in ${(kv)ENSURE_TOOLS_GO}; do
        if ! (( $+commands[$key] )); then
            cargo install $value
        fi
    done
}

