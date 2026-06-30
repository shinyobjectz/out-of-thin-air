#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" advertising-creative.title "Your Weekly Update")"
PREHEADER="$(param "$SESSION" advertising-creative.preheader "A quick note from us")"
BODY="$(param "$SESSION" advertising-creative.body "Thanks for reading. Here is what is new this week.")"
CTA="$(param "$SESSION" advertising-creative.cta "Read more")"

cat > "$OUT/email.html" <<EOF
<!DOCTYPE html>
<html lang="en" xmlns:v="urn:schemas-microsoft-com:vml" xmlns:o="urn:schemas-microsoft-com:office:office">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="x-apple-disable-message-reformatting">
<title>${TITLE}</title>
</head>
<body style="margin:0;padding:0;background-color:#f4f4f5;">
<div style="display:none;max-height:0;overflow:hidden;">${PREHEADER}</div>
<table role="presentation" width="100%" cellpadding="0" cellspacing="0" style="background-color:#f4f4f5;">
<tr><td align="center" style="padding:24px;">
<table role="presentation" width="600" cellpadding="0" cellspacing="0" style="max-width:600px;background-color:#ffffff;border-radius:8px;">
<tr><td style="padding:32px;font-family:Arial,sans-serif;color:#18181b;">
<h1 style="margin:0 0 16px;font-size:24px;">${TITLE}</h1>
<p style="margin:0 0 24px;font-size:16px;line-height:1.5;color:#3f3f46;">${BODY}</p>
<a href="#" style="display:inline-block;padding:12px 24px;background-color:#2563eb;color:#ffffff;text-decoration:none;border-radius:6px;font-size:16px;">${CTA}</a>
</td></tr>
</table>
</td></tr>
</table>
</body>
</html>
EOF
echo "  wrote out/email.html"

# Maizzle source template for a deterministic, email-safe build (v5: layout + Tailwind)
cat > "$OUT/template.html" <<EOF
<x-main>
  <table role="presentation" class="w-full">
    <tr>
      <td class="p-6 font-sans text-base text-gray-900">
        <h1 class="text-2xl mb-4">${TITLE}</h1>
        <p class="mb-6 text-gray-600">${BODY}</p>
        <a href="#" class="inline-block px-6 py-3 bg-blue-600 text-white rounded">${CTA}</a>
      </td>
    </tr>
  </table>
</x-main>
EOF
echo "  wrote out/template.html (Maizzle source)"

if command -v maizzle &>/dev/null; then
  maizzle build production && echo "  rendered build_production/**/*.html"
else
  echo "  hint: npx maizzle new maizzle/maizzle my-emails --install && cd my-emails && npx maizzle build production"
fi
