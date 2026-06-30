#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" motion-graphics.title "Sliding Box")"
WIDTH="$(param "$SESSION" motion-graphics.width "200")"
HEIGHT="$(param "$SESSION" motion-graphics.height "200")"
FILL="$(param "$SESSION" motion-graphics.fill "#e63")"
DUR="$(param "$SESSION" motion-graphics.dur "2s")"

cat > "$OUT/anim.svg" <<EOF
<svg xmlns="http://www.w3.org/2000/svg" width="$WIDTH" height="$HEIGHT" viewBox="0 0 $WIDTH $HEIGHT">
  <title>$TITLE</title>
  <rect width="40" height="40" fill="$FILL">
    <animateTransform attributeName="transform" type="translate"
      from="0 80" to="160 80" dur="$DUR" repeatCount="indefinite"/>
  </rect>
</svg>
EOF
echo "  wrote out/anim.svg"

# STATIC frame: validates well-formedness + initial composition (IGNORES SMIL timeline)
if command -v rsvg-convert &>/dev/null; then
  rsvg-convert -o "$OUT/frame.png" "$OUT/anim.svg" && echo "  rendered out/frame.png (t=0 static)"
else
  echo "  hint: brew install librsvg, then rsvg-convert -o frame.png anim.svg"
fi

# ANIMATED video: headless Chromium plays the SMIL clock, encodes mp4
if command -v svg-video &>/dev/null; then
  svg-video "$OUT/anim.svg" "$OUT/anim.mp4" && echo "  rendered out/anim.mp4 (animated)"
else
  echo "  hint: npm install -g svg-video (Node 22+, brew install ffmpeg), then svg-video anim.svg anim.mp4"
fi
