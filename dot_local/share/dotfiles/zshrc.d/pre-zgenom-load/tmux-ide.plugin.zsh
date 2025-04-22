export ZSH_TMUX_AUTOSTART=true

# If we're running under an editor, do not try to autostart tmux.
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  export ZSH_TMUX_AUTOSTART=false
  export ZSH_TMUX_AUTOCONNECT=false
fi
