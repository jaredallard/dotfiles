#!/usr/bin/env bash

is_at_work=$(xrandr | grep DP2 | awk '{ print $2 }')

if [[ "$is_at_work" == "connected" ]]; then
    echo "Setting up monitors for work"
    $HOME/.screenlayout/work.sh
    sleep 2
    $HOME/.background/set-bg.sh
    exit 0
fi

echo "not configuring for work" 
