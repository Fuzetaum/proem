#!bin/bash

# Replace rules in source file for their actual content
# $1 - source file path to replace rules

# exit code 1 if source file parameter is not provided
# exit code 2 if a rule file declares an invalid extension
# exit code 2 if a rule file is not found

if [ -z "$1" ]; then
    echo "Source file required" >&2
    exit 1
fi

harness_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

strip_frontmatter() {
    awk 'NR==1 && /^---[[:space:]]*$/ {fm=1; next}
         fm && /^---[[:space:]]*$/ {fm=0; next}
         !fm' "$1"
}

demote_headings() {
    awk '/^```/ {fence=!fence}
         !fence && /^#/ {print "#" $0; next}
         {print}'
}

rules="$(bash "$harness_dir/read_rules.sh" "$1")"
rules_dir="$harness_dir/../rules/"

output="$(cat "$harness_dir/../$1")"
while IFS= read -r file; do
    [ -z "$file" ] && continue
    case "$file" in
        *.md)
            rule_file="$rules_dir$file"
            ;;
        *.*)
            echo "Invalid extension: $file" >&2
            exit 2
            ;;
        *)
            rule_file="$rules_dir$file.md"
            ;;
    esac

    if [ ! -f "$rule_file" ]; then
        echo "Rule not found: $rule_file" >&2
        exit 3
    fi

    rule_content="$(strip_frontmatter "$rule_file" | demote_headings)"
    output=$(printf '%s\n' "$output" | awk '
        BEGIN { old = ARGV[1]; new = ARGV[2]; ARGV[1] = "-"; ARGV[2] = ""; ARGC = 2 }
        $0 == old { print new "\n"; next }
        { print }
        ' "$file" "$rule_content")
done <<< "$rules"

echo "$output"