#!/bin/bash

dotfile_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

. $dotfile_dir/tests/test_base.sh

header "Test Darwin"

test_symlink "${HOME}/.config/nvim"
test_symlink "${HOME}/.config/karabiner"
