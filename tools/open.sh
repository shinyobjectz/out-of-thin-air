#!/usr/bin/env bash
# Print the universal artifact-shell URL for a session (for agents / scripts).
# Usage: open.sh <slug>            or (legacy)  open.sh <type> <slug>
set -euo pipefail
if [ "$#" -ge 2 ]; then
  SLUG="$2"   # legacy: <type> <slug> — type is now just a hint, ignored
else
  SLUG="${1:?usage: open.sh <slug>}"
fi
PORT="${PORT:-4000}"
echo "http://localhost:${PORT}/projects/out-of-thin-air/components/artifact?slug=${SLUG}"
