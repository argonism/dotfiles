#!/bin/bash

set -eu

FAILED_COUNT=0

passed() { echo -e "\033[32m$*\033[0m"; }
failed() { echo -e "\033[31m$*\033[0m"; }

header() {
    local terminal_length=`tput cols`
    local input_text="$1"
    local input_length=${#input_text}
    local half_line_length=$(((terminal_length / 3) - (input_length + 1)))
    local half_line=$(printf "%${half_line_length}s" | tr ' ' '▭')
    echo "$half_line $input_text $half_line"
}

function test_symlink() {
    local source_path="$1"

    if [ -e $source_path ]; then
        if [ -L "$source_path" ]; then
            passed "$source_path"
        else
            failed "$source_path exists but not a symlink"
            FAILED_COUNT=$((FAILED_COUNT + 1))
        fi
    else
        failed "$source_path does not exist"
        FAILED_COUNT=$((FAILED_COUNT + 1))
    fi
}

function test_command_exists() {
    local cmd="$1"

    if which $cmd > /dev/null 2>&1; then
        passed "$cmd exists"
    else
        failed "$cmd does not exist"
        FAILED_COUNT=$((FAILED_COUNT + 1))
    fi
}

dotfile_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

header "Setup"

$dotfile_dir/install.sh

header "Test Base"

test_symlink "${HOME}/.zshrc"
test_symlink "${HOME}/.tmux.conf"
