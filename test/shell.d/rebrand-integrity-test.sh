#!/bin/bash

source "$(dirname "${BASH_SOURCE[0]}")/base-test.sh"

cd "$ROOT" || exit 1

python3 test/shell.d/rebrand-integrity-check.py