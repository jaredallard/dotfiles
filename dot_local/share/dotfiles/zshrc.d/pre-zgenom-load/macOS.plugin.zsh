#!/usr/bin/env zsh
# shellcheck shell=bash

# Ensure we have access to brew on macOS
if [[ "$OS" == "darwin" ]] && ! command -v "brew" >/dev/null; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
