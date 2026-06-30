#!/usr/bin/env bash
# Print JSON route proposal from requirements text (uses nexus API when board is up).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
REQ="${*:-}"
PORT="${PORT:-4010}"
if [[ -z "$REQ" ]]; then
  echo '{"error":"usage: oota route.sh \"requirements text\" [title]"}' >&2
  exit 1
fi
TITLE="${TITLE:-}"
if curl -sf "http://localhost:${PORT}/oota/catalog" >/dev/null 2>&1; then
  curl -sf -X POST "http://localhost:${PORT}/oota/route" \
    -H 'content-type: application/json' \
    -d "$(python3 -c 'import json,os,sys; print(json.dumps({"requirements":sys.argv[1],"title":os.environ.get("TITLE") or ""}))' "$REQ")"
else
  echo '{"error":"nexus not running — run oota serve or use the skill router offline"}' >&2
  exit 1
fi
