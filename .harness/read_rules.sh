#!/bin/bash

# Read all rules from a file
# $1 - source file path to read rules from

# exit code 1 if source file parameter is not provided

if [ -z "$1" ]; then
    echo "Source file required" >&2
    exit 1
fi

rules_block="# Rules"
root_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/../"

echo "$(awk "/^$rules_block/{flag=1; next} /^#/{flag=0} flag && NF" "$root_dir$1")"
