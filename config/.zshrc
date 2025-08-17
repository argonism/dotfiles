bindkey -v

source ~/.zsh/lib/aliases.zsh
source ~/.zsh/lib/functions.zsh

# git autocompletion
fpath=(~/.zsh $fpath)

# Environment-local configurations
if [[ -f ~/.zshrc.local ]]; then source ~/.zshrc.local; fi
if [[ -f ~/.zshrc.`uname` ]]; then source ~/.zshrc.`uname`; fi
