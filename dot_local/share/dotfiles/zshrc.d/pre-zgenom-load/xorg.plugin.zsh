#!/usr/bin/env zsh
# shellcheck shell=bash

# start xorg
if [[ "$OS" == "linux" ]]; then
  if [[ -t 0 && $(tty) == "/dev/tty1" && ! $DISPLAY ]]; then
    exec startx
  fi
fi
