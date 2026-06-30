#!/usr/bin/env bash
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" video.title "Motion")"
DUR="$(param "$SESSION" video.duration "3")"

cat > "$OUT/comp.html" <<EOF
<!DOCTYPE html>
<html><head><meta charset="utf-8"><title>$TITLE</title>
<style>
  body{margin:0;background:#09090b;color:#fafafa;font-family:system-ui;display:grid;place-items:center;height:100vh}
  h1{font-size:clamp(2rem,6vw,4rem);animation:fade 3s ease}
  @keyframes fade{from{opacity:0;transform:translateY(12px)}to{opacity:1;transform:none}}
</style></head>
<body><h1>$TITLE</h1></body></html>
EOF

echo "  wrote out/comp.html (${DUR}s placeholder — wire to HyperFrames render pipeline)"
