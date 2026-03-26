# function for grep
function find-grep(){
	find . -name \*.$1 -exec grep -nH $2 {} \;
}

# misc
function lines(){
	if [ $# -ne 0 ]; then
		sum=0
		for source in `find . -type f -name "*.$@"`
		do
			lines=`wc -l $source | sed -e "s/ [^ ]*$//" | sed -e "s/ //g"`
			sum=`expr $lines + $sum`
			printf "%6d $source\n" $lines
		done
		echo "Total: $sum"
	else
		echo "Usage: lines [extension]"
	fi
}

# command history analyzer
function analyze() {
	cat ~/.zsh_history | awk 'BEGIN {FS=";"} {print $2}' | awk '{print $1}' | sort | uniq -c | sort -nr | head -n 15
}

# replace foo bar #=> s/foo/bar/
function replace() {
	gg --name-only $1 | xargs sed -i "" -e "s/$1/$2/g"
}

# ask - Quick Q&A with Claude Code (streaming)
function ask() {
  if [ $# -eq 0 ]; then
    echo "Usage: ask <question>"
    return 1
  fi

  claude -p --model sonnet \
    --output-format stream-json \
    --verbose \
    --include-partial-messages \
    "$*" | jq --unbuffered -rj 'select(.type == "stream_event" and .event.delta.type? == "text_delta") | .event.delta.text'
  echo
}

function tmux-session-switch() {
  selected_line=$(tmux ls | cut -d : -f 1 | nl -w2 -s" " \
    | fzf --ansi --prompt="Select session> ")

  [ -z "$selected_line" ] && exit 0

  session=$(echo "$selected_line" | awk '{print $2}')

  tmux switch-client -t "$session"
}

# ================================
# Git Worktree Functions
# ================================

# gwa - Worktree Add & CD
# Usage: gwa <branch> [path]
# Creates a worktree and cd into it
# If path is omitted, creates at ../.worktrees/<branch>
function gwa() {
  if [ $# -eq 0 ]; then
    echo "Usage: gwa <branch> [path]"
    return 1
  fi

  local branch="$1"
  local path="${2:-../.worktrees/$branch}"

  # Create parent directory if needed
  mkdir -p "$(dirname "$path")"

  if git worktree add "$path" "$branch" 2>/dev/null; then
    cd "$path"
    echo "Created worktree at $path and switched to branch $branch"
  elif git worktree add -b "$branch" "$path" 2>/dev/null; then
    # Branch doesn't exist, create it
    cd "$path"
    echo "Created new branch $branch and worktree at $path"
  else
    echo "Failed to create worktree"
    return 1
  fi
}

# gwl - Worktree List
# Usage: gwl
function gwl() {
  git worktree list
}

# gwr - Worktree Remove
# Usage: gwr [path]
# If path is omitted, removes current worktree and returns to main
function gwr() {
  local path="${1:-$(pwd)}"
  local main_worktree

  # Get the main worktree path (first in the list)
  main_worktree=$(git worktree list --porcelain | grep "^worktree " | head -1 | cut -d' ' -f2)

  if [ "$path" = "$main_worktree" ]; then
    echo "Cannot remove main worktree"
    return 1
  fi

  # If removing current directory, cd to main first
  if [ "$path" = "$(pwd)" ]; then
    cd "$main_worktree"
  fi

  git worktree remove "$path"
  echo "Removed worktree at $path"
}

# gwc - Worktree CD (fzf integration)
# Usage: gwc
# Select a worktree with fzf and cd into it
function gwc() {
  local selected
  selected=$(git worktree list | fzf --prompt="Select worktree> " | awk '{print $1}')

  if [ -n "$selected" ]; then
    cd "$selected"
  fi
}
