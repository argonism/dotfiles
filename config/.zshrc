bindkey -v

source ~/.zsh/lib/go.zsh
source ~/.zsh/lib/aliases.zsh
source ~/.zsh/lib/basic.zsh
source ~/.zsh/lib/completion.zsh
source ~/.zsh/lib/functions.zsh
source ~/.zsh/lib/git.zsh

# Environment-local configurations
if [[ -f ~/.zshrc.local ]]; then source ~/.zshrc.local; fi
if [[ -f ~/.zshrc.`uname` ]]; then source ~/.zshrc.`uname`; fi

eval "$(starship init zsh)"

eval "$(mcfly init zsh)"

. ~/.zsh_alias
