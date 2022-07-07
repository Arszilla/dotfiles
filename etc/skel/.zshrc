export ZSH="/home/arszilla/.oh-my-zsh"

ZSH_THEME="clean"

# Plugins
plugins=(git zsh-autosuggestions zsh-completions)
autoload -U compinit && compinit

setopt +o nomatch

alias apt="sudo apt"
alias openvpn="sudo openvpn"
alias nmap="sudo nmap"
alias pbcopy="xsel --clipboard --input"
alias pbpaste="xsel --clipboard --output"

source $ZSH/oh-my-zsh.sh
