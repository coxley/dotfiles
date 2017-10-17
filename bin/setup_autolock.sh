#!/bin/bash
xautolock -time 5 -locker ~/bin/lock_screen -notify 20 -notifier 'xset dpms force off' &
# xautolock -time 7 -locker "systemctl suspend" &
