#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" advertising-creative.title "Welcome aboard")"
HEADLINE="$(param "$SESSION" advertising-creative.headline "Big news, just for you")"
CTA="$(param "$SESSION" advertising-creative.cta "Shop now")"

cat > "$OUT/email.mjml" <<EOF
<mjml>
  <mj-head>
    <mj-title>$TITLE</mj-title>
    <mj-attributes>
      <mj-all font-family="Helvetica, Arial, sans-serif" />
    </mj-attributes>
  </mj-head>
  <mj-body background-color="#f4f4f4">
    <mj-section background-color="#ffffff" padding="24px">
      <mj-column>
        <mj-text font-size="24px" font-weight="bold">$HEADLINE</mj-text>
        <mj-text font-size="14px" color="#555555">$TITLE</mj-text>
        <mj-button background-color="#1a73e8" href="https://example.com">$CTA</mj-button>
      </mj-column>
    </mj-section>
  </mj-body>
</mjml>
EOF
echo "  wrote out/email.mjml"

if command -v mjml &>/dev/null; then
  mjml "$OUT/email.mjml" -o "$OUT/email.html" && echo "  rendered out/email.html"
elif command -v npx &>/dev/null; then
  npx -y mjml@5.4.0 "$OUT/email.mjml" -o "$OUT/email.html" && echo "  rendered out/email.html"
else
  echo "  hint: npm install -g mjml@5.4.0 then: mjml $OUT/email.mjml -o $OUT/email.html"
fi
