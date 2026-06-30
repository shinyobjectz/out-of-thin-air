#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" comics-illustration.title "Annotated Board")"
COLUMNS="$(param "$SESSION" comics-illustration.columns "2")"
BALLOON_COLOR="$(param "$SESSION" comics-illustration.balloon_color "#1a1a1a")"

# vendor balloon.css next to the html so the artifact is self-contained
if command -v curl &>/dev/null; then
  curl -sL https://unpkg.com/balloon-css/balloon.min.css -o "$OUT/balloon.min.css" \
    && echo "  vendored out/balloon.min.css" \
    || echo "  hint: offline — link https://unpkg.com/balloon-css/balloon.min.css instead"
else
  echo "  hint: install curl, then: curl -sL https://unpkg.com/balloon-css/balloon.min.css -o balloon.min.css"
fi

cat > "$OUT/board.html" <<EOF
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>${TITLE}</title>
  <link rel="stylesheet" href="balloon.min.css">
</head>
<body style="--balloon-color:${BALLOON_COLOR};margin:0;background:#fff">
  <h1 style="font-family:sans-serif;padding:24px 48px 0">${TITLE}</h1>
  <main style="display:grid;grid-template-columns:repeat(${COLUMNS},1fr);gap:24px;padding:48px;font-family:sans-serif">
    <div aria-label="Panel one note" data-balloon-pos="up" data-balloon-visible data-balloon-blunt
         style="background:#fde68a;padding:32px;border:2px solid #000">Frame A</div>
    <div aria-label="Panel two note" data-balloon-pos="down" data-balloon-visible data-balloon-blunt
         style="background:#a7f3d0;padding:32px;border:2px solid #000">Frame B</div>
  </main>
</body>
</html>
EOF
echo "  wrote out/board.html"

# graceful-degrade raster: only if a downstream image/pdf kind is required
if command -v npx &>/dev/null; then
  npx playwright screenshot --full-page "$OUT/board.html" "$OUT/board.png" \
    && echo "  rendered out/board.png" \
    || echo "  hint: npm i -D playwright && npx playwright install chromium"
else
  echo "  hint: npm i -D playwright && npx playwright install chromium && npx playwright screenshot --full-page board.html board.png"
fi
