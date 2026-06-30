#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"
TITLE="$(param "$SESSION" web-ui-prototypes.title "Example/Button")"
LABEL="$(param "$SESSION" web-ui-prototypes.label "Click me")"

cat > "$OUT/Button.stories.jsx" <<EOF
import React from 'react';

const Button = ({ label }) => (
  <button type="button" style={{ padding: '11px 20px', border: 0, borderRadius: 4, background: '#1ea7fd', color: '#fff', fontWeight: 700, cursor: 'pointer' }}>
    {label}
  </button>
);

export default {
  title: '${TITLE}',
  component: Button,
};

export const Primary = {
  args: { label: '${LABEL}' },
};
EOF
echo "  wrote out/Button.stories.jsx"

echo "  scaffold only - build: npx storybook build -o out/storybook-static, then screenshot via Playwright"
