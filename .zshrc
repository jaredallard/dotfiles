# start xorg
if [[ -t 0 && $(tty) == "/dev/tty1" && ! $DISPLAY ]]; then
  exec startx
fi

# autostart tmux if not already running
if [[ -z "$TMUX" ]]; then

  if ! tmux attach; then
    exec tmux
  fi
fi

### share a ssh-agent session
if [[ ! -e "/tmp/ssh-agent" ]]; then
  ssh-agent > /tmp/ssh-agent
fi

source /tmp/ssh-agent 1>/dev/null 2>&1

### gpg-agent fixes
export GPG_TTY=$(tty)

### Plugins

# oh-my-zsh fixes
DISABLE_AUTO_UPDATE=true
ZSH="${HOME}/.cache/antibody/https-COLON--SLASH--SLASH-github.com-SLASH-robbyrussell-SLASH-oh-my-zsh"

# load antibody plugins
source ~/.zsh_plugins.sh

PROMPT='%{$fg[cyan]%}日本 %{$fg[magenta]%}[%c] %{$reset_color%}'

RPROMPT='%{$fg[magenta]%}$(git_prompt_info)%{$reset_color%} $(git_prompt_status)%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[cyan]%} ✈"
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%} ✭"
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✗"
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%} ➦"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[magenta]%} ✂"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[grey]%} ✱"

### BEGIN MY MODIFICATIONS
export PATH="$HOME/.bin:$HOME/go/bin:$HOME/.yarn/bin:${PATH}"

alias ls='ls --color=auto'
export EDITOR=nvim

alias gp='git push'
# kubectl
source <(kubectl completion zsh)
source <(kops completion zsh)
source <(stern --completion=zsh)
# my aliases for kubectl
alias k=kubectl

# kubectl get
alias kg='k get'
alias kgp='kg pod'
alias kgs='kg service'
alias kgd='kg deployment'
alias kgse='kg secret'
alias kgss='kg statefulset'
alias kgn='kg node'

# kubectl describe
alias kd='k describe'
alias kdp='kd pod'
alias kds='kd service'
alias kdd='kd deployment'
alias kdse='kd secret'
alias kdss='kd statefulset'
alias kdn='kd node'

# kubectl delete 
alias kde='k delete'
alias kdep='kde pod'
alias kdes='kde svc'
alias kded='kde deployment'
alias kdese='kde secret'
alias kdess='kde statefulset'

# misc
alias ke='k exec -it'
alias kl='k logs -f'
alias sudo='sudo -E'

## azuquactl
alias a='azuquactl'

# azuquactl context
alias ac='a context'

# azuquactl auth
alias aak='a auth kubernetes'

# azuquactl development
alias ad='a development'
alias adt='ad tests'
alias adtls='adt list-jobs'
alias adtl='adt logs'


# Go
export GOPATH="$HOME/go"

### Fuzzy finder shit i never use
if fzf --version >/dev/null; then
  if [[ $- == *i* ]]; then
    # CTRL-T - Paste the selected file path(s) into the command line
    __fsel() {
      local cmd="${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
        -o -type f -print \
        -o -type d -print \
        -o -type l -print 2> /dev/null | cut -b3-"}"
      setopt localoptions pipefail 2> /dev/null
      eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_CTRL_T_OPTS" $(__fzfcmd) -m "$@" | while read item; do
        echo -n "${(q)item} "
      done
      local ret=$?
      echo
      return $ret
    }

    __fzf_use_tmux__() {
      [ -n "$TMUX_PANE" ] && [ "${FZF_TMUX:-0}" != 0 ] && [ ${LINES:-40} -gt 15 ]
    }

    __fzfcmd() {
      __fzf_use_tmux__ &&
        echo "fzf-tmux -d${FZF_TMUX_HEIGHT:-40%}" || echo "fzf"
    }

    fzf-file-widget() {
      LBUFFER="${LBUFFER}$(__fsel)"
      local ret=$?
      zle redisplay
      typeset -f zle-line-init >/dev/null && zle zle-line-init
      return $ret
    }
    zle     -N   fzf-file-widget
    bindkey '^T' fzf-file-widget

    # Ensure precmds are run after cd
    fzf-redraw-prompt() {
      local precmd
      for precmd in $precmd_functions; do
        $precmd
      done
      zle reset-prompt
    }
    zle -N fzf-redraw-prompt

    # ALT-C - cd into the selected directory
    fzf-cd-widget() {
      local cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune \
        -o -type d -print 2> /dev/null | cut -b3-"}"
      setopt localoptions pipefail 2> /dev/null
      local dir="$(eval "$cmd" | FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} --reverse $FZF_DEFAULT_OPTS $FZF_ALT_C_OPTS" $(__fzfcmd) +m)"
      if [[ -z "$dir" ]]; then
        zle redisplay
        return 0
      fi
      cd "$dir"
      local ret=$?
      zle fzf-redraw-prompt
      typeset -f zle-line-init >/dev/null && zle zle-line-init
      return $ret
    }
    zle     -N    fzf-cd-widget
    bindkey '\ec' fzf-cd-widget

    # CTRL-R - Paste the selected command from history into the command line
    fzf-history-widget() {
      local selected num
      setopt localoptions noglobsubst noposixbuiltins pipefail 2> /dev/null
      selected=( $(fc -rl 1 |
        FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} $FZF_DEFAULT_OPTS -n2..,.. --tiebreak=index --bind=ctrl-r:toggle-sort $FZF_CTRL_R_OPTS --query=${(qqq)LBUFFER} +m" $(__fzfcmd)) )
      local ret=$?
      if [ -n "$selected" ]; then
        num=$selected[1]
        if [ -n "$num" ]; then
          zle vi-fetch-history -n $num
        fi
      fi
      zle redisplay
      typeset -f zle-line-init >/dev/null && zle zle-line-init
      return $ret
    }
    zle     -N   fzf-history-widget
    bindkey '^R' fzf-history-widget
  fi
fi

# Autocomplete for some wrapper utils
_klc() {
  COMPREPLY=( $(kubectl get pod --template "{{ range .items }}{{ .metadata.name }} {{ end }}") )
}

_kubectx() {
  COMPREPLY=($(kubectl config get-contexts --output='name'))
}

complete -F _kubectx kubectx
complete -F _klc klc

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/jared/google-cloud-sdk/path.zsh.inc' ]; then source '/home/jared/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/jared/google-cloud-sdk/completion.zsh.inc' ]; then source '/home/jared/google-cloud-sdk/completion.zsh.inc'; fi

# The next line enablse shell command completion for azure :puke:
if [ -f "$HOME/azure-cli/az.completion" ]; then source /home/jared/azure-cli/az.completion; fi

# azuquactl
export PATH="${PATH}:/home/jared/.azuquactl"
