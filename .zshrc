# start xorg
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi

if [[ -z "$TMUX" ]]; then
  if ! tmux attach; then
    exec tmux
  fi
fi

source $HOME/antigen.zsh

### Plugins
antigen use oh-my-zsh

antigen bundle git
antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme theunraveler
antigen apply

### BEGIN MY MODIFICATIONS
export PATH="$HOME/.bin:$HOME/go/bin:${PATH}"

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


# Go
export GOPATH="$HOME/go"

# Colin's cool jump shit
export MARKPATH="$HOME/.marks"

j() {
  if [[ -z $1 ]]; then
    mrk=$(ls $MARKPATH | fzf --border)
  else
    mrk=$1
  fi
  cd -P "$MARKPATH/$mrk" 2> /dev/null || (echo "No such mark: $mrk" && marks)
}

mark() {
  mrk="$*"
  mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$mrk"
}

unmark() {
  mrk="$*"
  rm -i "$MARKPATH/$mrk"
}

marks() {
  ls -l "$MARKPATH" | sed 's/  / /g' | cut -d' ' -f9- && echo
}


if ! fzf --version >/dev/null; then
    zplug "junegunn/fzf", use:"shell/completion.zsh"                 # fzf
    zplug "junegunn/fzf", use:"shell/key-bindings.zsh"               # fzf
fi
