#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" motion-graphics.title "Hello Lottie")"
WIDTH="$(param "$SESSION" motion-graphics.width "512")"
HEIGHT="$(param "$SESSION" motion-graphics.height "512")"
BG="$(param "$SESSION" motion-graphics.background "#ffffff")"
FORMAT="$(param "$SESSION" motion-graphics.format "mp4")"

# Minimal valid Lottie/Bodymovin JSON: a single solid layer, 60 frames @ 30fps.
cat > "$OUT/anim.json" <<EOF
{
  "v": "5.7.4",
  "fr": 30,
  "ip": 0,
  "op": 60,
  "w": ${WIDTH},
  "h": ${HEIGHT},
  "nm": "${TITLE}",
  "ddd": 0,
  "assets": [],
  "layers": [
    {
      "ddd": 0,
      "ind": 1,
      "ty": 1,
      "nm": "${TITLE}",
      "sr": 1,
      "ks": {
        "o": { "a": 1, "k": [
          { "t": 0,  "s": [0],   "i": { "x": [0.5], "y": [1] }, "o": { "x": [0.5], "y": [0] } },
          { "t": 30, "s": [100] },
          { "t": 60, "s": [0] }
        ] },
        "r": { "a": 0, "k": 0 },
        "p": { "a": 0, "k": [$((WIDTH/2)), $((HEIGHT/2)), 0] },
        "a": { "a": 0, "k": [$((WIDTH/2)), $((HEIGHT/2)), 0] },
        "s": { "a": 0, "k": [100, 100, 100] }
      },
      "sw": ${WIDTH},
      "sh": ${HEIGHT},
      "sc": "#3366ff",
      "ip": 0,
      "op": 60,
      "st": 0,
      "bm": 0
    }
  ]
}
EOF
echo "  wrote out/anim.json"

case "$FORMAT" in
  gif) EXT="gif" ;;
  png) EXT="png" ;;
  *)   EXT="mp4" ;;
esac

if [ "$EXT" = "png" ]; then
  TARGET="$OUT/frame-%d.png"
  DELIV="out/frame-%d.png"
else
  TARGET="$OUT/animation.${EXT}"
  DELIV="out/animation.${EXT}"
fi

if command -v puppeteer-lottie &>/dev/null; then
  puppeteer-lottie -i "$OUT/anim.json" -o "$TARGET" --width "$WIDTH" --height "$HEIGHT" -b "$BG" \
    && echo "  rendered ${DELIV}"
else
  echo "  hint: npm install -g puppeteer-lottie-cli && brew install ffmpeg gifski"
  echo "        then: puppeteer-lottie -i $OUT/anim.json -o $TARGET --width $WIDTH --height $HEIGHT -b '$BG'"
fi
