#!/usr/bin/env zsh
# shellcheck shell=bash

# general aliases
alias kg='k get'
alias kd='k describe'
alias kdel='k delete'

# Use 1Password ssh-agent
export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"

# If we have tmux, automatically start it
if hash tmux &>/dev/null; then
  export ZSH_TMUX_AUTOSTART=true
fi

# If we have fd, use it with fzf
if hash fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND=fd
fi

# cat -> bat, syntax highlighting
if hash bat &>/dev/null || hash batcat &>/dev/null; then
  commandName="bat"
  if hash batcat &>/dev/null; then
    commandName="batcat"

    # nice to have, alias bat to batcat
    alias bat="$commandName"
  fi
  alias cat="$commandName --tabs 2"
fi

# Replace ls with a better version ;)
if hash lsd &>/dev/null; then
  alias ls='lsd --group-dirs first'
fi
