export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="clean"

# Plugins
plugins=(git zsh-autosuggestions zsh-completions)
autoload -U compinit && compinit

setopt +o nomatch                           # Used by plugins
setopt autocd                               # Change directory just by typing its name
setopt interactivecomments                  # Allow comments in interactive mode
setopt nonomatch                            # Hide error message if there is no match for the pattern
setopt notify                               # Report the status of background jobs immediately
setopt promptsubst                          # Enable command substitution in prompt
setopt numericglobsort                      # Sort filenames numerically when it makes sense

# Aliases
alias apt="sudo apt"                        # apt
alias history="history 0"                   # Force zsh to show the complete history
alias kobe="git push"                       # git
alias nmap="sudo nmap"                      # nmap
alias openvpn="sudo openvpn"                # OpenVPN
alias pbcopy="xsel --clipboard --input"     # Used for certain msfvenom payloads
alias pbpaste="xsel --clipboard --output"   # Used for certain msfvenom payloads
alias yeet="git push --force"               # git
alias yoink="git pull"                      # git

# QoL
PROMPT_EOL_MARK=""                          # Hide EOL sign ('%')
new_line_before_prompt=yes                  # Prompt a newline

source $ZSH/oh-my-zsh.sh
