<!-- generated draft — needs validation -->
# HTMLCSStoImage (HCTI)

slug: `htmlcsstoimage` · category: `advertising-creative` · artifact kind: **image**

## Summary

HTMLCSStoImage (HCTI, hcti.io) is a hosted REST API that renders HTML/CSS to
high-quality PNG/JPG/WebP images (and PDF) using a Chrome rendering engine. You
author deterministic, version-controllable HTML + CSS, POST it to the API, and
download a pixel image — a clean fit for OOTA's `image` kind (social cards, ad
creative, certificates, dynamic graphics).

**Caveat (load-bearing for OOTA):** HCTI is a CLOUD service, NOT a local
headless renderer. It requires a User ID + API Key (HTTP Basic) and a network
round-trip; rendering happens on their servers and returns a CDN URL you must
download. So the markup is deterministic and version-controllable, but the
render step is NOT fully local/headless on macOS and depends on a paid account
(free tier 50 imgs/mo). Supports a Template API (`{{variables}}`), batch (up to
25 images/request), Google Fonts, and viewport/device emulation. If you need
true local deterministic image-from-markup with no SaaS dependency, prefer a
local Chromium/Playwright or wkhtmltoimage path instead.

## Skills

| name | type | official | url | license | attribution |
|------|------|----------|-----|---------|-------------|
| HTML/CSS to Image MCP Server | mcp | official | https://docs.htmlcsstoimage.com/integrations/mcp/ | proprietary/SaaS | htmlcsstoimage (official). Install: `claude mcp add hcti --transport http https://mcp.hcti.io` ; browser OAuth on first use |
| HCTI API docs | docs | official | https://docs.htmlcsstoimage.com/ | proprietary | official docs; source repo https://github.com/htmlcsstoimage/docs |
| Community HCTI skill (curl examples) | skill | community | https://docs.htmlcsstoimage.com/integrations/ | unverified | community-authored curl HTML/CSS render + URL screenshot examples; unverified license, reference only |

## Toolchains

| lang | install | invoke |
|------|---------|--------|
| shell (curl) | preinstalled on macOS | `POST https://hcti.io/v1/image` with Basic auth `USER_ID:API_KEY`; response JSON `.url`/`.id`; download `{url}.png\|.jpg\|.webp\|.pdf` |
| javascript (Node 18+) | native fetch, or `npm i node-fetch`/axios | fetch POST with `Authorization: Basic base64(user:key)` |
| python (CPython) | `pip install requests` | `requests.post('https://hcti.io/v1/image', auth=(user,key), json={'html':...,'css':...})` |
| ruby | `gem install httparty` (or net/http stdlib) | official Ruby integration |
| php | `composer require guzzlehttp/guzzle` (or curl ext) | official PHP integration |
| csharp (.NET) | `HttpClient` built-in | official C# integration |
| go | `net/http` stdlib | official GoLang integration |
| vbnet (.NET) | built-in | official VB.NET integration |

## Artifact kind

**image** — primary deliverable is a rendered PNG/JPG/WebP (PDF also supported).

## Validation

- **install:** curl preinstalled on macOS; export `HCTI_USER` and `HCTI_KEY`
  from your hcti.io dashboard (free tier, 50 images/mo).
- **smoke:**
  ```bash
  ID=$(curl -s -X POST https://hcti.io/v1/image -u "$HCTI_USER:$HCTI_KEY" \
    -H 'Content-Type: application/json' \
    -d '{"html":"<div class=card>OOTA</div>","css":".card{font-family:sans-serif;font-size:48px;padding:40px;background:#111;color:#fff}"}' \
    | python3 -c 'import sys,json;print(json.load(sys.stdin)["id"])')
  curl -s "https://hcti.io/v1/image/$ID.png" -o /tmp/oota.png
  file /tmp/oota.png
  ```
- **expect:** `/tmp/oota.png` exists and `file` reports `PNG image data`.
  Requires valid HCTI credentials + network (NOT fully offline/local).

## Wrapper params

- `advertising-creative.title` (text) — headline rendered into the card.
- `advertising-creative.html` (textarea) — HTML fragment.
- `advertising-creative.css` (textarea) — CSS string.
- `advertising-creative.format` (select: png/jpg/webp/pdf) — output format.

## Component / explorer notes

Deliverable component = a deterministic HTML fragment + CSS string (and optional
Template with `{{variables}}`). Plain text, fully version-controllable. Use the
Template API to separate markup from data so one template renders many ad
variants. Pin `google_fonts` and explicit `viewport_width`/`viewport_height`/
`device_scale` for reproducible pixels. The batch endpoint renders up to 25
variants per request — ideal for ad-creative sweeps.

**Wrapper must:** (1) inject credentials from env, (2) POST html/css or
`template_id`+`template_values`, (3) follow `.url`/`.id` and GET `{id}.png` to
materialize the file, (4) handle the 50/mo free-tier limit and rate/billing
errors. This breaks OOTA's "renders headlessly on macOS" guarantee — use HCTI
only when managed Chrome fidelity + Template/batch API outweigh the cloud
dependency.
