#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" typography.title "Untitled")"
GLYPH="$(param "$SESSION" typography.glyph "A")"
UNICODE="$(param "$SESSION" typography.unicode "0041")"
WIDTH="$(param "$SESSION" typography.width "600")"
UPM="$(param "$SESSION" typography.upm "1000")"
ASCENDER="$(param "$SESSION" typography.ascender "750")"
DESCENDER="$(param "$SESSION" typography.descender "-250")"
COMPILE="$(param "$SESSION" typography.compile "none")"

mkdir -p "$OUT/src"

cat > "$OUT/src/build_font.py" <<EOF
# generated draft — needs validation
# FontParts UFO source generator — https://fontparts.robotools.dev/en/stable/
from fontParts.world import RFont

f = RFont(showInterface=False)
f.info.familyName = "${TITLE}"
f.info.unitsPerEm = ${UPM}
f.info.ascender = ${ASCENDER}
f.info.descender = ${DESCENDER}

g = f.newGlyph("${GLYPH}")
g.unicode = 0x${UNICODE}
g.width = ${WIDTH}

# Draw the glyph outline via a segment pen. Edit these calls to shape your glyph.
pen = g.getPen()
pen.moveTo((50, 0))
pen.lineTo((300, 700))
pen.lineTo((550, 0))
pen.closePath()

f.save("out/font.ufo")
print("glyphs:", len(f))
EOF
echo "  wrote out/src/build_font.py"

# graceful render: build the UFO source if python+fontParts available
if command -v python3 &>/dev/null && python3 -c "import fontParts" &>/dev/null; then
  ( cd "$OUT" && python3 src/build_font.py ) && echo "  rendered out/font.ufo"
  if [ "$COMPILE" != "none" ] && command -v fontmake &>/dev/null; then
    ( cd "$OUT" && fontmake -u font.ufo -o "$COMPILE" ) && echo "  compiled out/ (${COMPILE})"
  elif [ "$COMPILE" != "none" ]; then
    echo "  hint: pip install fontmake && fontmake -u out/font.ufo -o ${COMPILE}"
  fi
else
  echo "  hint: python3 -m venv /tmp/fpv && /tmp/fpv/bin/pip install fontParts && /tmp/fpv/bin/python out/src/build_font.py"
fi
