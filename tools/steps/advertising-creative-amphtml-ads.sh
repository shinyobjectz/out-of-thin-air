#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" advertising-creative.title "Hello Ad")"
SUBTEXT="$(param "$SESSION" advertising-creative.subtext "Your message here.")"
ACCENT="$(param "$SESSION" advertising-creative.accent "#1a73e8")"
WIDTH="$(param "$SESSION" advertising-creative.width "300")"
HEIGHT="$(param "$SESSION" advertising-creative.height "250")"

cat > "$OUT/ad.html" <<EOF
<!doctype html>
<html ⚡4ads lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,minimum-scale=1">
  <script async src="https://cdn.ampproject.org/amp4ads-v0.js"></script>
  <style amp4ads-boilerplate>body{visibility:hidden}</style>
  <style amp-custom>
    body{margin:0;font-family:sans-serif}
    .ad{width:${WIDTH}px;height:${HEIGHT}px;display:flex;flex-direction:column;
        justify-content:center;align-items:center;text-align:center;box-sizing:border-box;padding:16px}
    h1{color:${ACCENT};margin:0 0 8px;font-size:22px}
    p{color:#333;margin:0;font-size:14px}
  </style>
</head>
<body>
  <div class="ad">
    <h1>${TITLE}</h1>
    <p>${SUBTEXT}</p>
  </div>
</body>
</html>
EOF
echo "  wrote out/ad.html"

if command -v amphtml-validator &>/dev/null; then
  amphtml-validator --html_format AMP4ADS "$OUT/ad.html" && echo "  validated out/ad.html (PASS)"
else
  echo "  hint: npm install -g amphtml-validator then amphtml-validator --html_format AMP4ADS $OUT/ad.html"
fi
