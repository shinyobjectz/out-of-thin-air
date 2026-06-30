#!/usr/bin/env bash
# Shared param reader for code-as step scripts.
# Usage: param SESSION key.default → value
param() {
  local file="$1" key="$2" default="${3:-}"
  local val
  val="$(awk -v k="$key" '
    /^params do$/,/^end$/ {
      if ($0 ~ "^[[:space:]]*" k ":") {
        sub(/^[[:space:]]*[^:]*:[[:space:]]*/, "", $0)
        gsub(/^"/, "", $0); gsub(/"$/, "", $0)
        print $0; exit
      }
    }' "$file")"
  if [[ -n "$val" ]]; then echo "$val"; else echo "$default"; fi
}
