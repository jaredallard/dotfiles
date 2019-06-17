#!/usr/bin/env bash

num_displays=$(xrandr | grep " connected " | awk '{ print$1 }' | wc -l)

echo "Number of connected displays: $num_displays"
if [[ "$num_displays" == "4" ]]; then
  echo "Setting up monitors for work"
  $HOME/.screenlayout/work.sh
  sleep 2
  $HOME/.background/set-bg.sh
  exit 0
else
  echo "noop"
fi
