#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" typography.title "Proof")"
LETTER="$(param "$SESSION" typography.glyph_letter "A")"
STROKE="$(param "$SESSION" typography.stroke_width "0.4")"
SLANT="$(param "$SESSION" typography.slant "0")"
XHEIGHT="$(param "$SESSION" typography.x_height "5")"
MODE="$(param "$SESSION" typography.mode "localfont")"
MAG="$(param "$SESSION" typography.mag "4")"

mkdir -p "$OUT/src"

cat > "$OUT/src/font.mf" <<EOF
% $TITLE — minimal parametric Metafont source
mode_setup;

% --- design parameters (editable; drive the whole family) ---
em#       := 10pt#;        % design size
x_height# := ${XHEIGHT}pt#; % x-height
stroke#   := ${STROKE}pt#;  % pen stroke width
slant     := ${SLANT};      % obliqueness
define_pixels(em, x_height);
define_blacker_pixels(stroke);

% slant the coordinate system
currenttransform := identity slanted slant yscaled aspect_ratio;

beginchar("$LETTER", em#, x_height#, 0);
  pickup pencircle scaled stroke;
  % a simple parametric 'A'-like stroke pair + crossbar
  z1 = (0, 0);
  z2 = (.5w, h);
  z3 = (w, 0);
  z4 = .5[z1,z2];
  z5 = .5[z3,z2];
  draw z1 -- z2 -- z3;     % the two diagonals
  draw z4 -- z5;           % crossbar
  labels(1,2,3,4,5);
endchar;

end.
EOF

echo "  wrote out/src/font.mf"

if command -v mf-nowin &>/dev/null; then
  ( cd "$OUT/src" && mf-nowin "\\mode=$MODE; mode_setup; mag=$MAG; nonstopmode; input font" >/dev/null 2>&1 || true )
  GF="$(ls "$OUT"/src/font.*gf 2>/dev/null | head -n1 || true)"
  if [ -n "$GF" ] && command -v gftodvi &>/dev/null && command -v dvipng &>/dev/null; then
    ( cd "$OUT/src" && gftodvi "$(basename "$GF")" >/dev/null 2>&1 && \
      dvipng -D150 -o "$OUT/font-proof.png" font.dvi >/dev/null 2>&1 || true )
    [ -f "$OUT/font-proof.png" ] && echo "  rendered out/font-proof.png" \
      || echo "  hint: gftodvi src/font.*gf && dvipng -D150 -o font-proof.png font.dvi"
  else
    echo "  hint: gftodvi src/font.*gf && dvipng -D150 -o font-proof.png font.dvi"
  fi
else
  echo "  hint: brew install --cask mactex-no-gui  # then: mf-nowin '\\mode=localfont; mode_setup; mag=4; nonstopmode; input src/font' && gftodvi src/font.*gf && dvipng -D150 -o font-proof.png font.dvi"
fi
