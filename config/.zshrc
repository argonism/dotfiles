bindkey -v

source ~/.zsh/lib/aliases.zsh
source ~/.zsh/lib/functions.zsh

# git autocompletion
fpath=(~/.zsh/fpath $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
autoload -Uz compinit && compinit

# Environment-local configurations
if [[ -f ~/.zshrc.local ]]; then source ~/.zshrc.local; fi
if [[ -f ~/.zshrc.`uname` ]]; then source ~/.zshrc.`uname`; fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/k-ush/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

if (which zprof > /dev/null) ;then
  # zprof | less
fi
