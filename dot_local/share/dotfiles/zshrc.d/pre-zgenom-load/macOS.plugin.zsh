#!/usr/bin/env zsh
# shellcheck shell=bash

# Ensure we have access to brew on macOS if it's installed
if [[ "$OS" == "darwin" ]] && ! command -v "brew" >/dev/null && [[ -e /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
