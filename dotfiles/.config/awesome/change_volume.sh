#!/bin/bash

ids=$( pactl list sinks | grep "Sink #" | cut -d# -f2 )

for id in $ids; do
    pactl -- set-sink-volume $id "$1"
done
