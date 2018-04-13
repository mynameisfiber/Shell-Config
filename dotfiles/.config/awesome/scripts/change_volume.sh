#!/bin/bash

pactl -- set-sink-volume @DEFAULT_SOURCE@ "$1"
