#!/usr/bin/env zsh
# shellcheck shell=bash

# completion & other not important things
lazyload rtx -- 'source <(rtx activate zsh)'
lazyload kubectl -- 'source <(kubectl completion zsh)'
