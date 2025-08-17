bindkey -v

source ~/.zsh/lib/aliases.zsh
source ~/.zsh/lib/functions.zsh

# git autocompletion
fpath=(~/.zsh/fpath $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash

# Environment-local configurations
if [[ -f ~/.zshrc.local ]]; then source ~/.zshrc.local; fi
if [[ -f ~/.zshrc.`uname` ]]; then source ~/.zshrc.`uname`; fi
