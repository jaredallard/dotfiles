#!/usr/bin/env bash
# Script to setup a new machine.
# Handing as much work off, as possible
# to chezmoi.
#
# Environment variables:
#  - OS: The operating system to setup for, valid values are:
#    - linux
#    - darwin
set -euo pipefail

if [[ -z "$OS" ]]; then
  OS=$(uname | tr '[:upper:]' '[:lower:]')
fi

# log prints a line to the terminal and formats it to be easier
# to read vs other output
log() {
  echo "$(tput bold)" "$@" "$(tput sgr0)"
}

log "Started machine init: OS=$OS,ARCH=$ARCH"

# run_chezmoi bootstraps chezmoi and runs it with our dotfiles
run_chezmoi() {
  log " -> Running chezmoi"
  if ! command -v chezmoi >/dev/null; then
    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply jaredallard
  else
    chezmoi update
  fi
}

if [[ "$OS" != "darwin" && "$OS" != "linux" ]]; then
  echo "Unsupported OS: $OS" 2>/dev/null
  exit 1
fi

run_chezmoi
