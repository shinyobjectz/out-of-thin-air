#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" advertising-creative.title "Hello OOTA")"
BODY="$(param "$SESSION" advertising-creative.body "Your responsive email, built from React components.")"
CTA_LABEL="$(param "$SESSION" advertising-creative.cta_label "Buy")"
CTA_HREF="$(param "$SESSION" advertising-creative.cta_href "https://example.com")"

mkdir -p "$OUT/src"

cat > "$OUT/src/email.tsx" <<EOF
import { Html, Head, Preview, Body, Container, Heading, Text, Button } from '@react-email/components';

export const Email = () => (
  <Html>
    <Head />
    <Preview>${TITLE}</Preview>
    <Body style={{ fontFamily: 'sans-serif', backgroundColor: '#f6f6f6' }}>
      <Container style={{ padding: '24px' }}>
        <Heading>${TITLE}</Heading>
        <Text>${BODY}</Text>
        <Button href="${CTA_HREF}" style={{ background: '#000', color: '#fff', padding: '12px 20px', borderRadius: '6px' }}>
          ${CTA_LABEL}
        </Button>
      </Container>
    </Body>
  </Html>
);

export default Email;
EOF
echo "  wrote out/src/email.tsx"

cat > "$OUT/render.tsx" <<'EOF'
import { render } from '@react-email/render';
import { writeFileSync } from 'node:fs';
import Email from './src/email';

const html = await render(<Email />, { pretty: true });
writeFileSync('email.html', html);
console.log('bytes:', html.length);
EOF
echo "  wrote out/render.tsx"

if command -v npx &>/dev/null && [ -d "$OUT/node_modules/@react-email/render" ]; then
  ( cd "$OUT" && npx --yes tsx render.tsx ) && echo "  rendered out/email.html"
else
  echo "  hint: npm install -E @react-email/render @react-email/components react react-dom tsx then 'npx tsx render.tsx'"
fi
