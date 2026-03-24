#!/usr/bin/env zsh

osascript -e '
global windowWidth
global windowHeight
tell application "System Events"
        tell application process "Ghostty"
        set dimensions to size of front window
        set windowWidth to item 1 of dimensions
        set windowHeight to item 2 of dimensions
    end tell
end tell

tell application "Ghostty"
    activate

    set win to front window
    set term to focused terminal of selected tab of win
    set pwd to working directory of term

    set cfg to new surface configuration
    set initial working directory of cfg to pwd

    set rightPane to term
    set topLeft to split rightPane direction left with configuration cfg
    set bottomLeft to split topLeft direction down with configuration cfg

    perform action "resize_split:down,"& windowHeight div 8 on topLeft
    perform action "resize_split:left," & windowWidth div 6 on rightPane
    focus rightPane
end tell'
