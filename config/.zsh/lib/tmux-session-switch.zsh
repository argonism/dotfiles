#!/usr/bin/env zsh

selected_line=$(tmux ls | cut -d : -f 1 | nl -w2 -s" " \
  | fzf --ansi --prompt="Select session> ")

[ -z "$selected_line" ] && exit 0

session=$(echo "$selected_line" | awk '{print $2}')

tmux switch-client -t "$session"
