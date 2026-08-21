#!/bin/bash

source ~/.bashrc
xmodmap ~/.Xmodmap

if [[ "$(cat /etc/hostname)X" = "featherX" ]]; then
    xrandr -o 3
    screen-zoom =0.6
fi

exec awesome
