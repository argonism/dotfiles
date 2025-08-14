bindkey -v

source ~/.zsh/lib/aliases.zsh
source ~/.zsh/lib/functions.zsh

# Environment-local configurations
if [[ -f ~/.zshrc.local ]]; then source ~/.zshrc.local; fi
if [[ -f ~/.zshrc.`uname` ]]; then source ~/.zshrc.`uname`; fi

eval "$(starship init zsh)"

eval "$(mcfly init zsh)"
