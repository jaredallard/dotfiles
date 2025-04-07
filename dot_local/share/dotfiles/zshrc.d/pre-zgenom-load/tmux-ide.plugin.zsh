export ZSH_TMUX_AUTOSTART=true

# If we're running under cursor or VS Code, do not try to autostart tmux.
if pstree -p $$ | grep -Ei "cursor|vscode|visual studio code|zed" | grep -vq "grep"; then
  export ZSH_TMUX_AUTOSTART=false
  export ZSH_TMUX_AUTOCONNECT=false
fi
