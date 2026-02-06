#!/usr/bin/env zsh

aerospace_dev() {
    # Grab current workspace and existing Ghostty window IDs
    local ws=$(aerospace list-workspaces --focused)
    local before=$(ghostty_windows)
    local count=$(echo $before | wc -l)

    # Spawn a new ghostty window, and wait until it's visible to aerospace.
    spawn_ghostty
    while [[ $(ghostty_windows | wc -l) -eq $count ]]; do
        sleep 0.01
    done

    # Fetch the new window's ID
    local after=$(ghostty_windows)
    local left=$(comm -13 <(echo $before | sort) <(echo $after | sort))
    count=$(echo $after | wc -l)

    # Navigate the new window to $HOME
    #
    # This is a bit weird, but it's because Ghostty doesn't expose sophisticated
    # AppleScript to launch a window in a specific directory. The directory depends on
    # the config, but it defaults to the same directory as the last active window.
    osascript -e 'tell application "System Events" to keystroke "cd ~" & return'
    while [[ $(ghostty_window_title $left) != "~" ]]; do
        sleep 0.01
    done

    # Spawn two more windows and wait until they're visible
    spawn_ghostty
    spawn_ghostty
    while [[ $(ghostty_windows | wc -l) -eq $count ]]; do
        sleep 0.01
    done

    # Create the following layout:
    #
    # ┌─────┬─────────┐
    # │  1  │         │
    # │     │         │
    # ├─────┤    3    │
    # │  2  │         │
    # │     │         │
    # └─────┴─────────┘
    aerospace join-with --window-id $left right
    aerospace resize --window-id $left width -300
}

spawn_ghostty() {
    osascript -e '
        tell application "Ghostty"
        if it is running then
            activate
            tell application "System Events" to keystroke "n" using {command down}
        else
            activate
        end if
        end tell
    '
}

ghostty_windows() {
    aerospace list-windows --app-bundle-id com.mitchellh.ghostty --monitor all --json | jq '.[] | .["window-id"]'
}

ghostty_window_title() {
    aerospace list-windows --workspace focused --app-bundle-id com.mitchellh.ghostty --json | jq -r ".[] | select(.[\"window-id\"] == $1) | .[\"window-title\"]"
}

aerospace_dev
