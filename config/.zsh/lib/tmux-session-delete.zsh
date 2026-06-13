#!/usr/bin/env zsh

# Invoked from tmux-session-switch.zsh via fzf --bind.
# $1 is the highlighted line, e.g. " 3 my-session".

line="$1"
session=$(echo "$line" | awk '{print $2}')

[ -z "$session" ] && exit 0

current=$(tmux display-message -p '#S' 2>/dev/null)
if [ "$session" = "$current" ]; then
  printf '\nCannot delete the current session (%s). Press enter to continue. ' "$session" > /dev/tty
  read -r _ < /dev/tty
  exit 0
fi

printf '\nDelete session "%s"? [y/N] ' "$session" > /dev/tty
read -r ans < /dev/tty
case "$ans" in
  y|Y|yes|YES)
    tmux kill-session -t "$session"
    ;;
esac
