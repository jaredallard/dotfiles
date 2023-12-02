#!/usr/bin/env zsh
# shellcheck shell=bash
isWSL=$([[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]] && echo "true" || echo "false")

## WSL2 Support
# Check if we're running in WSL2
if [[ "$isWSL" == "true" ]]; then
  # Windows specific paths to prevent issues with syntax highlighting speed.
  export PATH="$PATH:/mnt/c/Program Files/Microsoft VS Code/bin"
  export PATH="$PATH:/mnt/c/Program Files/Docker/Docker/resources/bin"
  export PATH="$PATH:/mnt/c/WINDOWS"

  # Ensure npiperelay.exe is installed
  if ! command -v npiperelay.exe >/dev/null; then
    echo "Please install npiperelay.exe from https://github.com/albertony/npiperelay"
    sleep 15
    exit 0
  fi

  export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"

  # Configure ssh forwarding as per: https://1password.community/discussion/128023/ssh-agent-on-windows-subsystem-for-linux
  # need `ps -ww` to get non-truncated command for matching
  # use square brackets to generate a regex match for the process we want but that doesn't match the grep command running it!
  if ! ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; then
    # Ensure the directory exists
    local dir="$(dirname "$SSH_AUTH_SOCK")"
    if [[ ! -e "$dir" ]]; then
      mkdir -p "$dir"
    fi

    # If the SSH_AUTH_SOCK already exists, remove it because no forwarding command is running.
    if [[ -S $SSH_AUTH_SOCK ]]; then
      rm -f "$SSH_AUTH_SOCK"
    fi

    # setsid to force new session to keep running
    # set socat to listen on $SSH_AUTH_SOCK and forward to npiperelay which then forwards to openssh-ssh-agent on windows
    (setsid socat UNIX-LISTEN:"$SSH_AUTH_SOCK",fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
  fi
fi
