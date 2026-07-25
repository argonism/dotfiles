bindkey -v

source ~/.zsh/lib/aliases.zsh
source ~/.zsh/lib/functions.zsh
source ~/.zsh/lib/1password-envs.zsh

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

# Fix tmux soft-wrap copy issue
autoload -U add-zsh-hook
tmux_fix_soft_wrap_selections() {
  if [[ -n "$TMUX" ]]; then
    tmux refresh
  fi
}
add-zsh-hook precmd tmux_fix_soft_wrap_selections

if (which zprof > /dev/null) ;then
  # zprof | less
fi
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
