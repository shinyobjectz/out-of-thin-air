#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(dirname "$0")"
exec bash "$SCRIPT_DIR/_scaffold.sh" "$1" "$2" electronics skidl
