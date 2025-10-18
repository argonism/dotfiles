#!/bin/bash

dotfile_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

. $dotfile_dir/tests/test_base.sh

header "Test Linux"

test_symlink "${HOME}/.config/nvim"
test_symlink "${HOME}/.config/starship.toml"
test_symlink "${HOME}/.tmux.conf"
test_symlink "${HOME}/.tmux.conf.local"
test_symlink "${HOME}/.zshrc"
test_symlink "${HOME}/.zshrc.Linux"

test_command_exists "btop"
test_command_exists "curl"
test_command_exists "fzf"
test_command_exists "git"
test_command_exists "tmux"
test_command_exists "xclip"

if [ $FAILED_COUNT -gt 0 ]; then
    failed "Failed $FAILED_COUNT tests"
    exit 1
else
    passed "All tests passed"
fi
