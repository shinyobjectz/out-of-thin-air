#!/usr/bin/env bash
# generated draft — needs validation
set -euo pipefail
SESSION="$1" OUT="$2"
source "$(dirname "$0")/_params.sh"

TITLE="$(param "$SESSION" markup.title "Hello")"
COLLECTION="$(param "$SESSION" markup.collection "blog")"
FORMAT="$(param "$SESSION" markup.format "md")"

# --- content entry --------------------------------------------------------
mkdir -p "$OUT/src/content/$COLLECTION"
cat > "$OUT/src/content/$COLLECTION/post.$FORMAT" <<EOF
---
title: $TITLE
---

# Hi

body **md** — authored as plain markup, rendered to static HTML.
EOF
echo "  wrote out/src/content/$COLLECTION/post.$FORMAT"

# --- collection config ----------------------------------------------------
cat > "$OUT/src/content.config.ts" <<EOF
import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const $COLLECTION = defineCollection({
  loader: glob({ pattern: '**/*.{md,mdx}', base: './src/content/$COLLECTION' }),
  schema: z.object({ title: z.string() }),
});

export const collections = { $COLLECTION };
EOF
echo "  wrote out/src/content.config.ts"

# --- page that renders the collection to HTML -----------------------------
mkdir -p "$OUT/src/pages/$COLLECTION"
cat > "$OUT/src/pages/$COLLECTION/[id].astro" <<EOF
---
import { getCollection, render } from 'astro:content';
export async function getStaticPaths() {
  const posts = await getCollection('$COLLECTION');
  return posts.map((p) => ({ params: { id: p.id }, props: { post: p } }));
}
const { post } = Astro.props;
const { Content } = await render(post);
---
<html><head><title>{post.data.title}</title></head><body><Content /></body></html>
EOF
echo "  wrote out/src/pages/$COLLECTION/[id].astro"

# --- build hint (never run heavy/network builds inline) -------------------
if command -v astro &>/dev/null; then
  echo "  hint: astro found — run 'cd $OUT && astro build' to emit static HTML to ./dist"
else
  echo "  hint: npm create astro@latest -- --template minimal -y && npm install && npx astro add mdx -y && npx astro build"
fi
echo "  note: PDF via headless print, e.g. chromium --headless --print-to-pdf dist/$COLLECTION/post/index.html"
