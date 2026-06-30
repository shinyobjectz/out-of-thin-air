# CSS Grid + balloon.css

Slug: `balloon-css` · Category: `comics-illustration`

## Summary

balloon.css is a ~1.1kb pure-CSS tooltip library (MIT, kazzkiq) that attaches
hover/visible tooltips to any element via `aria-label` + `data-balloon-pos`
attributes, with zero JavaScript. Paired with native CSS Grid it lets OOTA
author deterministic, version-controllable HTML+CSS layouts — annotated panels,
illustrated callout boards, comic-style grids with speech-bubble tooltips —
that render headlessly in any browser. No official Anthropic/Claude skill
exists; the only artifact is the static CSS file consumed by handwritten HTML
markup. Tooltips trigger on `:hover` or the `data-balloon-visible` attribute, so
for a deterministic headless capture you set `data-balloon-visible` to force
bubbles open. Latest balloon.css is v1.0.0 (2019-06-18); CSS Grid is a stable
web standard requiring no dependency.

## Skills

| Name | Type | Official | License | URL |
|------|------|----------|---------|-----|
| balloon.css (library, not a skill) | community | no | MIT | https://github.com/kazzkiq/balloon.css |
| balloon.css official docs/demo | community | no | MIT | https://kazzkiq.github.io/balloon.css/ |
| CSS Grid Layout (MDN reference) | standard | yes | CC-BY-SA (docs); W3C royalty-free spec | https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_grid_layout |

Attribution: balloon.css by kazzkiq (Claudio Holanda). CSS Grid reference by
MDN / W3C CSS Working Group.

## Toolchains

| Lang | Install | Invoke |
|------|---------|--------|
| HTML/CSS | `npm install balloon-css` or CDN `https://unpkg.com/balloon-css/balloon.min.css` | Link/inline the stylesheet into the HTML; open in any browser. No build step. The HTML file IS the deliverable. |
| JavaScript/Node (optional raster) | `npm install -D playwright && npx playwright install chromium` | `npx playwright screenshot --full-page index.html out.png` — only when a non-HTML kind is required. |

CSS Grid is native to the browser; no install. balloon.css is a single
stylesheet linked or inlined into the HTML.

## Artifact kind

`html` — primary deliverable is a self-contained `.html` file. It can be
screenshot to `image`/`pdf` via headless Chromium if a raster is needed.

## Validation

Install:
```bash
mkdir -p /tmp/balloon-smoke && cd /tmp/balloon-smoke && curl -sL https://unpkg.com/balloon-css/balloon.min.css -o balloon.min.css
```

Smoke:
```bash
cat > /tmp/balloon-smoke/index.html <<'EOF'
<!doctype html><html><head><meta charset="utf-8"><link rel="stylesheet" href="balloon.min.css"></head>
<body style="--balloon-color:#1a1a1a">
<main style="display:grid;grid-template-columns:repeat(2,1fr);gap:24px;padding:48px;font-family:sans-serif">
  <div aria-label="Panel one note" data-balloon-pos="up" data-balloon-visible style="background:#fde68a;padding:32px;border:2px solid #000">Frame A</div>
  <div aria-label="Panel two note" data-balloon-pos="down" data-balloon-visible style="background:#a7f3d0;padding:32px;border:2px solid #000">Frame B</div>
</main></body></html>
EOF
test -s /tmp/balloon-smoke/index.html && test -s /tmp/balloon-smoke/balloon.min.css && echo OK
# optional raster: npx playwright screenshot --full-page /tmp/balloon-smoke/index.html /tmp/balloon-smoke/out.png
```

Expect: `index.html` and `balloon.min.css` both exist non-empty and `OK` prints.
Opening `index.html` in any browser shows a 2-column CSS Grid with two bordered
comic panels, each displaying a forced-open tooltip bubble
(`data-balloon-visible`). Optional Playwright step emits `out.png` with the
bubbles rendered. Fully headless and deterministic on macOS.

## Wrapper params

- `comics-illustration.title` (text) — page/board title.
- `comics-illustration.columns` (range) — grid column count.
- `comics-illustration.balloon_color` (color) — `--balloon-color` theme var.

## Component / explorer notes

Two orthogonal pieces:
1. **CSS Grid** handles the panel/page layout deterministically
   (`grid-template-columns/rows`, `gap`, `grid-area`) — ideal for comic strips,
   callout boards, illustrated reference sheets.
2. **balloon.css** overlays annotation tooltips on grid cells via `aria-label`
   (text) + `data-balloon-pos` (up/down/left/right/up-left/up-right/down-left/
   down-right). Tooltip length: `data-balloon-length=small|medium|large|fit`.
   `data-balloon-blunt` disables the fade animation. Theme vars:
   `--balloon-color`, `--balloon-font-size`, `--balloon-move`. Tooltip text
   lives in `aria-label` so it is also accessible.

CRITICAL for headless determinism: balloon tooltips only appear on `:hover` by
default, which never fires in a static headless render. Always add
`data-balloon-visible` to every element whose tooltip must show in the captured
output, and add `data-balloon-blunt` to skip the entrance animation so
screenshots are stable. Inline/vendor `balloon.min.css` into the HTML rather
than relying on a live CDN to keep the artifact self-contained and reproducible
offline. Primary output is the `.html` file itself; only invoke
Playwright/Chromium if a downstream image or pdf kind is explicitly required.
