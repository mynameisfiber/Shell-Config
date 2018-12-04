#!/bin/sh

exec flock -n /var/lock/$USER.xautolock.lock \
    xautolock -detectsleep \
        -time 5 -locker "i3lock -d -c 000070" \
        -notify 30 \
        -notifier "notify-send -u critical -t 10000 -- 'LOCKING screen in 30 seconds'"
