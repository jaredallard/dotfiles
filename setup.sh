#!/usr/bin/env bash
# Script to setup a new machine.
# Handing as much work off as possible to chezmoi.
set -euo pipefail

# OS is the operating system to setup for, valid values are:
#  - linux
#  - darwin
OS=${OS:-$(uname | tr '[:upper:]' '[:lower:]')}

# ARCH is the architecture to setup for, valid values are:
#  - x86_64
#  - arm64
ARCH=${ARCH:-$(uname -m | tr '[:upper:]' '[:lower:]')}

# log prints a line to the terminal and formats it to be easier
# to read vs other output
log() {
  echo -e "\033[1m" "$@" "\033[0m"
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
