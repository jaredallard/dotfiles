#!/usr/bin/env zsh
# shellcheck shell=bash

# completion & other not important things
if hash brew &>/dev/null; then
  asdfPath="$(brew --prefix asdf)/libexec"
else
  asdfPath="$HOME/.asdf"
fi

lazyload asdf -- 'source "$asdfPath/asdf.sh"'
lazyload kubectl -- 'source <(kubectl completion zsh)'
