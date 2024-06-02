#!/usr/bin/env zsh
# shellcheck shell=bash

# general aliases
alias kg='k get'
alias kd='k describe'
alias kdel='k delete'

# Load homebrew installed things over pre-installed macOS versions.
if hash brew &>/dev/null; then
  PATH="/opt/homebrew/bin:${PATH}"
  export PATH
fi

# Use neovim as the default editor if installed.
if hash nvim &>/dev/null; then
  export EDITOR=nvim
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

# If we have tmux, automatically start it. Exception: Don't run when
# we're in VSCode. It doesn't make a ton of sense to use tmux within a
# vscode session.
if hash tmux &>/dev/null && [[ -z "$TMUX" ]] && [[ -z "$VSCODE_NONCE" ]]; then
  exec tmux
fi
