#!bin/bash

# Reads given file, replaces all of its tokens in an in-memory copy, and prints the postprocessed copy to stdout
# $1 - source file path to replace tokens

# exit code 1 if source file parameter is not provided
# exit code 1 if an unsupported token key is found

if [ -z "$1" ]; then
    echo "Source file required" >&2
    exit 1
fi

strip_frontmatter() {
    awk 'NR==1 && /^---[[:space:]]*$/ {fm=1; next}
         fm && /^---[[:space:]]*$/ {fm=0; next}
         fm {next}
         !started && /^[[:space:]]*$/ {next}
         {started=1; print}' "$1"
}

demote_headings() {
    awk '/^```/ {fence=!fence}
         !fence && /^#/ {print "#" $0; next}
         {print}'
}

replace_from_file() {
    printf '%s\n' "$2" | awk -v old="$3" -v new="$(cat "$1")" '
        $0 == old { print new; next }
        { print }
    '
}

replace_parameter() {
    printf '%s\n' "$2" | awk -v old="$3" -v new="Parameter $1" '
        BEGIN { old_len = length(old) }
        old_len > 0 {
            out = ""
            while ((idx = index($0, old)) > 0) {
                out = out substr($0, 1, idx - 1) new
                $0 = substr($0, idx + old_len)
            }
            $0 = out $0
        }
        { print }
    '
}

HARNESS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.."

# Load all supported token types from the source config file
declare -A token_types
while IFS=$'\t' read -r key value; do
    token_types["$key"]="$value"
done < <(yq -r 'to_entries[] | [.key, (.value | to_entries | map(.key + "=" + (.value | tostring)) | join(":"))] | @tsv' "$HARNESS_DIR/token-replacement/token-types.yaml")

source_file_content="$(strip_frontmatter "$HARNESS_DIR/../$1")"
while IFS=: read -r key value; do
    if [ -z "${token_types["$key"]}" ]; then
        echo "Unsupported token key: $key" >&2
        exit 2
    fi

    file_token="{{$key:$value}}"
    case "$key" in
        parameter)
            source_file_content="$(replace_parameter "10" "$source_file_content" "$file_token")"
            ;;
        *)
            source_file_content="$(replace_from_file "$HARNESS_DIR/../${key}s/$value.md" "$source_file_content" "$file_token")"
            ;;
    esac
done < <(grep -oE '\{\{[^}]*:[^}]*\}\}' <<< "$source_file_content" | tr -d '{}')

echo "$source_file_content"
