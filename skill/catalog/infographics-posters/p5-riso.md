<!-- generated draft — needs validation -->
# p5.riso

## Summary
p5.riso is a p5.js add-on library (Sam Lavigne & Tega Brain) for generating Risograph-print-ready artwork. Each ink is modeled as a separate `Riso` layer; the library automates color separation, previews the composite, and exports each color channel as a separate PNG via `exportRiso()` (72 dpi default). It is pure browser JavaScript layered on p5.js — no native Node/headless API — so deterministic headless rendering on macOS requires driving the sketch in a headless Chromium (Puppeteer/Playwright) and capturing the canvas or intercepting the PNG downloads.

Primary deliverable = **image** (one PNG per ink layer; layers flatten to a composite preview image). SVG/PDF export is NOT supported.

**License caveat:** Anti-Capitalist Software License (ACSL) — NOT a standard OSI license. Permits use only by individuals and non-capitalist / worker-owned orgs, and forbids law-enforcement / military use. Surface this before bundling in any commercial OOTA package.

## Skills
| Name | Type | URL | Official | License | Attribution |
|------|------|-----|----------|---------|-------------|
| p5.riso official docs + tutorials | documentation | https://antiboredom.github.io/p5.riso/ | official | ACSL 1.4 | Sam Lavigne & Tega Brain; web by Crystal Chen, Paolla Bruno Dutra |
| antiboredom/p5.riso (source + getting-started) | repo | https://github.com/antiboredom/p5.riso | official | ACSL | Sam Lavigne & Tega Brain |
| Secret Riso Club — Javascript & Riso guide | community-guide | https://secretrisoclub.com/Javascript-Riso | community | n/a (web article) | Secret Riso Club |
| NYU IDM — P5 Riso Printing | community-guide | https://idm.engineering.nyu.edu/index.php/p5-riso-printing/ | community | n/a | NYU IDM |

## Toolchains
| Lang | Install | Invoke |
|------|---------|--------|
| JavaScript (Browser / p5.js) | Vendor via `<script>`: p5.js (`https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js`) then p5.riso (`https://raw.githack.com/antiboredom/p5.riso/master/lib/riso.js`). No npm package — copy `lib/riso.js` from the repo. | `new Riso('color')` → draw into layer → `drawRiso()` preview / `exportRiso()` triggers per-layer PNG downloads. |
| JavaScript/TS (Node + headless Chromium) | `npm i puppeteer` | Load HTML sketch in headless Chromium, wait for draw, then `page.screenshot` the composite canvas OR override `save()`/intercept downloads to write per-layer PNG buffers. p5.riso has no standalone Node renderer. |

## Artifact kind
**image** — N single-channel PNGs (one per ink), re-combined on the Riso; a flattened composite preview can also be captured.

## Validation
**install:**
```
mkdir riso-smoke && cd riso-smoke && npm init -y && npm i puppeteer \
  && curl -L https://raw.githack.com/antiboredom/p5.riso/master/lib/riso.js -o riso.js \
  && curl -L https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.9.0/p5.min.js -o p5.min.js
```
**smoke:** `sketch.html` loads p5.min.js + riso.js; `setup()` does `createCanvas(300,300); let r=new Riso('red'); r.ellipse(150,150,200,200); drawRiso();`. Node script: launch puppeteer, `page.goto('file://.../sketch.html')`, wait for canvas, `page.$eval('canvas',c=>c.toDataURL())`, write base64 to `out.png`.

**expect:** `out.png` written — a 300×300 PNG showing a red-channel ellipse on white. Confirms headless render emits an image file with zero GUI. (Per-layer separated PNGs require overriding `exportRiso`'s download path to capture each Riso layer buffer.)

## Wrapper params
- `infographics-posters.title` (text) — poster title text.
- `infographics-posters.colors` (text) — comma-separated ink names (e.g. `red,blue`).
- `infographics-posters.scale` (range) — canvas px / 72 = print inches; scale up for print quality.

## Component / explorer notes
- Deterministic given fixed seed: drawing is deterministic, but any `random()`/`noise()` must be seeded (`randomSeed`/`noiseSeed`) for identical version-controllable output.
- Default export = 72 dpi PNG; for print-quality posters scale the canvas up (resolution = canvas px / 72 in).
- Output is N separate single-channel PNGs (one per ink); composite preview capturable from visible canvas.
- No npm package and no native headless renderer — vendor `lib/riso.js` + p5.js locally and drive headless Chromium; `exportRiso()`/`save()` relies on browser download, so the wrapper must intercept downloads (Playwright `page.on('download')`) or read layer buffers via `canvas.toDataURL` and write with `fs`.
- ACSL license restricts use to individuals and non-profit/worker-owned orgs and bars law-enforcement/military use — flag before shipping commercially.
