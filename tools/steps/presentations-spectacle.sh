#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" presentations.title "Hello Spectacle")"
THEME="$(param "$SESSION" presentations.theme "dark")"
TRANSITION="$(param "$SESSION" presentations.transition "slide")"
CODE_LANG="$(param "$SESSION" presentations.code_language "javascript")"

mkdir -p "$OUT/src"

# minimal valid Spectacle deck (React/TSX) — the source the user edits
cat > "$OUT/src/App.tsx" <<EOF
import { Deck, Slide, Heading, Text, CodePane } from 'spectacle';

const theme = { colors: { primary: '${THEME}' === 'light' ? '#222' : '#fff' } };

export default function App() {
  return (
    <Deck theme={theme} transition={{ from: { opacity: 0 }, enter: { opacity: 1 }, leave: { opacity: 0 } }}>
      <Slide>
        <Heading>${TITLE}</Heading>
        <Text>A live, navigable Spectacle deck. Use arrow keys to advance.</Text>
      </Slide>
      <Slide>
        <Heading>Code</Heading>
        <CodePane language="${CODE_LANG}">{\`const greet = (name) => \\\`Hi \\\${name}\\\`;\nconsole.log(greet('world'));\`}</CodePane>
      </Slide>
    </Deck>
  );
}
EOF
echo "  wrote out/src/App.tsx"

# minimal index.html + entry so the deck is buildable/servable
cat > "$OUT/index.html" <<'EOF'
<!doctype html>
<html><head><meta charset="utf-8"><title>Spectacle deck</title></head>
<body><div id="root"></div><script type="module" src="/src/main.tsx"></script></body></html>
EOF
echo "  wrote out/index.html"

cat > "$OUT/src/main.tsx" <<'EOF'
import { createRoot } from 'react-dom/client';
import App from './App';
createRoot(document.getElementById('root')!).render(<App />);
EOF
echo "  wrote out/src/main.tsx"

# graceful render: build the HTML deck if a JS toolchain is present, else hint
if command -v npm &>/dev/null; then
  echo "  toolchain: install deps then build the HTML deck"
  echo "  hint: cd $OUT && npm install spectacle react react-dom && npm create vite@latest . -- --template react-ts && npm run build  (emits dist/index.html)"
  echo "  hint (PDF): npm run dev & ; npx -y decktape automatic http://localhost:5173/ deck.pdf"
else
  echo "  hint: install Node.js + npm, then: npm install spectacle react react-dom && npm run build"
fi
