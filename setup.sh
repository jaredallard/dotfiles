#!/usr/bin/env bash
# Script to setup a new machine.
# Handing as much work off, as possible
# to chezmoi.
#
# Environment variables:
#  - OS: The operating system to setup for, valid values are:
#    - linux
#    - macos
#  - ARCH: The architecture to setup for, valid values are:
#    - amd64
#    - arm64

set -e

if [[ -z "$OS" ]]; then
  OS=$(uname | tr '[:upper:]' '[:lower:]')
fi
if [[ -z "$ARCH" ]]; then
  ARCH=$(uname -m | tr '[:upper:]' '[:lower:]')
  if [[ "$ARCH" == "x86_64" ]]; then
    ARCH="amd64"
  elif [[ "$ARCH" == "aarch64" ]]; then
    ARCH="arm64"
  fi
fi

# log prints a line to the terminal and formats it to be easier
# to read vs other output
log() {
  echo "$(tput bold)" "$@" "$(tput sgr0)"
}

log "Started machine init: OS=$OS,ARCH=$ARCH"

# setup_1password installs 1Password and configures it
setup_1password() {
  log " -> Setting up 1Password"
  if ! command -v op >/dev/null; then
    if [[ "$OS" == "darwin" ]]; then
      setup_1password_darwin
    elif [[ "$OS" == "linux" ]]; then
      setup_1password_linux
    fi
  fi

  if op account list | grep -q "my"; then
    log " -> 1Password already configured"
  else
    log " -> Configuring 1Password"
    read -rp "Please enter your 1Password email: " EMAIL
    op account add --address my.1password.com --email "$EMAIL"
    eval "$(op signin --account my)"
  fi
}

setup_1password_linux() {
  curl -sS https://downloads.1password.com/linux/keys/1password.asc |
    sudo gpg --dearmor --output /usr/share/keyrings/1password-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/1password-archive-keyring.gpg] https://downloads.1password.com/linux/debian/$(dpkg --print-architecture) stable main" |
    sudo tee /etc/apt/sources.list.d/1password.list
  sudo mkdir -p /etc/debsig/policies/AC2D62742012EA22/
  curl -sS https://downloads.1password.com/linux/debian/debsig/1password.pol |
    sudo tee /etc/debsig/policies/AC2D62742012EA22/1password.pol
  sudo mkdir -p /usr/share/debsig/keyrings/AC2D62742012EA22
  curl -sS https://downloads.1password.com/linux/keys/1password.asc |
    sudo gpg --dearmor --output /usr/share/debsig/keyrings/AC2D62742012EA22/debsig.gpg
  sudo apt update && sudo apt install 1password-cli
}

setup_1password_darwin() {
  LATEST_CASK=$(curl -s "https://raw.githubusercontent.com/1Password/homebrew-tap/main/Casks/1password-cli.rb")
  LATEST_CASK_VERSION=$(echo "$LATEST_CASK" | grep "version \"" | awk '{ print $2 }' | tr -d '"')
  DOWNLOAD_URL=$(echo "$LATEST_CASK" | grep "url \"" | awk '{ print $2 }' | tr -d '"' | sed s\|\#\{version\}\|"$LATEST_CASK_VERSION"\|g)
  TEMP_FILE=$(mktemp)
  trap 'rm -f $TEMP_FILE' EXIT

  curl -fsSLo "$DOWNLOAD_URL" "$TEMP_FILE"
  sudo installer -verbose -pkg "$TEMP_FILE" -target /
  rm -f "$TEMP_FILE"
}

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

setup_1password
run_chezmoi
