#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" web-ui-prototypes.title "Signature")"
CONCEPT="$(param "$SESSION" web-ui-prototypes.concept "A single bold hero with one signature element.")"
ACCENT="$(param "$SESSION" web-ui-prototypes.accent "#3b2fb5")"

cat > "$OUT/page.html" <<EOF
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>${TITLE}</title>
<style>
  :root { --accent: ${ACCENT}; --ink: #14110f; --paper: #f4f1ea; }
  * { box-sizing: border-box; }
  body { margin: 0; font: 16px/1.5 system-ui, sans-serif; background: var(--paper); color: var(--ink); }
  main { max-width: 56rem; margin: 0 auto; padding: 6rem 1.5rem; }
  h1 { font-size: clamp(2.5rem, 8vw, 5rem); line-height: 1.02; letter-spacing: -0.03em; margin: 0 0 1rem; }
  .signature { display: inline-block; width: 4rem; height: 0.4rem; background: var(--accent); margin-bottom: 2rem; }
  p { max-width: 38ch; font-size: 1.15rem; }
  a:focus-visible { outline: 3px solid var(--accent); outline-offset: 3px; }
  @media (prefers-reduced-motion: reduce) { * { animation: none !important; transition: none !important; } }
</style>
</head>
<body>
  <main>
    <span class="signature" aria-hidden="true"></span>
    <h1>${TITLE}</h1>
    <p>${CONCEPT}</p>
  </main>
</body>
</html>
EOF
echo "  wrote out/page.html"

CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
if [ -x "$CHROME" ]; then
  "$CHROME" --headless --disable-gpu --screenshot="$OUT/page.png" \
    --window-size=1280,800 "file://$OUT/page.html" && echo "  rendered out/page.png"
elif command -v chromium &>/dev/null; then
  chromium --headless --disable-gpu --screenshot="$OUT/page.png" \
    --window-size=1280,800 "file://$OUT/page.html" && echo "  rendered out/page.png"
else
  echo "  hint: install Google Chrome/Chromium then: chrome --headless --screenshot=out/page.png file://\$PWD/out/page.html"
fi
