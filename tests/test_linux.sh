#!/bin/bash

dotfile_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

. $dotfile_dir/tests/test_base.sh

if [ $FAILED_COUNT -gt 0 ]; then
    failed "Failed $FAILED_COUNT tests"
    exit 1
else
    passed "All tests passed"
fi
