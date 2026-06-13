#!/usr/bin/env zsh

selected_line=$(tmux ls | cut -d : -f 1 | nl -w2 -s' ' \
  | fzf --ansi \
      --prompt='Select session> ' \
      --header='enter: switch / ctrl-d: delete' \
      --bind "ctrl-d:execute(zsh ${HOME}/.zsh/lib/tmux-session-delete.zsh {})+reload(tmux ls | cut -d : -f 1 | nl -w2 -s' ')")

[ -z "$selected_line" ] && exit 0

session=$(echo "$selected_line" | awk '{print $2}')

tmux switch-client -t "$session"
