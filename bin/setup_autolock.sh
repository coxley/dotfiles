#!/bin/bash
xautolock -time 5 -locker ~/bin/lock_screen -notify 20 -notifier 'xset dpms force off' &
xss-lock -- i3lock -n -c 000000 &
# xautolock -time 7 -locker "systemctl suspend" &
