#!/usr/bin/env bash
# Build Remotion Player preview bundle (served via nexus — no separate port).
set -euo pipefail
PROJECT="$(cd "$(dirname "$0")/.." && pwd)"
SLUG="${1:?usage: preview.sh <slug> [start|stop|status]}"
ACTION="${2:-status}"
OUT="$PROJECT/cli/sessions/$SLUG/out"
PIDFILE="$OUT/.preview.pid"
PORTFILE="$OUT/.preview.port"
LOG="$OUT/.preview.log"
TEMPLATE="$PROJECT/cli/_template"
BUNDLE="$OUT/preview-player/index.html"

stop_preview() {
  if [[ -f "$PIDFILE" ]]; then
    pid="$(cat "$PIDFILE")"
    kill "$pid" 2>/dev/null || true
    pkill -P "$pid" 2>/dev/null || true
    rm -f "$PIDFILE" "$PORTFILE"
  fi
}

start_preview() {
  [[ -f "$OUT/package.json" ]] || { echo "error: no Remotion project at $OUT" >&2; exit 1; }
  [[ -f "$OUT/src/player-site.tsx" ]] || { echo "error: missing out/src/player-site.tsx" >&2; exit 1; }
  stop_preview
  cd "$OUT"
  if [[ ! -d node_modules ]]; then
    echo "→ npm install"
    npm install
  fi
  if ! npm ls @remotion/player >/dev/null 2>&1; then
    echo "→ npm install @remotion/player"
    npm install @remotion/player@^4.0.0
  fi
  mkdir -p preview-player
  cp "$TEMPLATE/remotion-player-shell.html" preview-player/index.html
  echo "→ esbuild player bundle"
  npx esbuild src/player-site.tsx \
    --bundle \
    --outfile=preview-player/bundle.js \
    --format=iife \
    --loader:.tsx=tsx \
    --jsx=automatic \
    --platform=browser \
    >>"$LOG" 2>&1
  echo "nexus" > "$PORTFILE"
  echo "preview: /projects/out-of-thin-air/cli/sessions/$SLUG/out/preview-player/index.html"
  exit 0
}

status_preview() {
  if [[ -f "$BUNDLE" ]]; then
    echo "running"
    echo "port: nexus"
  else
    echo "stopped"
  fi
}

case "$ACTION" in
  start) start_preview ;;
  stop) stop_preview; rm -rf "$OUT/preview-player"; echo "stopped" ;;
  status) status_preview ;;
  *) echo "usage: preview.sh <slug> start|stop|status" >&2; exit 1 ;;
esac
