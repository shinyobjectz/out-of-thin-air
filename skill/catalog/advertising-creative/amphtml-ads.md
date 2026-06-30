# AMPHTML ads

## Summary

AMPHTML ads (AMP4ADS) are a constrained, spec-defined HTML format for fast, secure ad creatives. An ad is a single deterministic `.html` document marked with the `⚡4ads` / `amp4ads` attribute on `<html>`, loading the `amp4ads-v0.js` runtime, and restricted to the AMP4ADS element subset. It renders headlessly and is mechanically verifiable with the official `amphtml-validator` CLI (`--html_format AMP4ADS`), making it an excellent fit for OOTA: version-controllable markup, deterministic output, hard pass/fail validation. No build step is required to produce the artifact — it is plain HTML.

No official Anthropic/Claude skill exists; authority is the `ampproject/amphtml` repo + amp.dev docs.

## Skills

| Skill | Type | Official | License | URL | Attribution |
|---|---|---|---|---|---|
| AMPHTML / AMP4ADS create-an-ad guide | official-docs | yes | CC-BY-4.0 (docs) | https://amp.dev/documentation/guides-and-tutorials/start/create_amphtml_ad/ | The AMP Project / amp.dev |
| AMPHTML ad spec & validator source (ampproject/amphtml) | community-repo | yes | Apache-2.0 | https://github.com/ampproject/amphtml/blob/main/validator/README.md | ampproject/amphtml (Google / OpenJS Foundation) |
| Intro to AMPHTML ads (format/spec primer) | official-docs | yes | CC-BY-4.0 | https://amp.dev/documentation/guides-and-tutorials/learn/intro-to-amphtml-ads/ | The AMP Project |
| Hello World amp4ads example (minimal valid markup) | official-example | yes | CC-BY-4.0 | https://amp.dev/documentation/examples/introduction/amphtml_ads_hello_world/ | The AMP Project |

## Toolchains

| Lang | Install | Invoke |
|---|---|---|
| JavaScript/Node.js (>=12) | `npm install -g amphtml-validator` | `amphtml-validator --html_format AMP4ADS ad.html` (programmatic: `const v = await require('amphtml-validator').getInstance(); v.validateString(html, 'AMP4ADS')`) |

The validator CLI is the canonical deterministic pass/fail gate. The ad artifact itself is plain `.html` requiring no compile step. GUI authoring tools (Google Web Designer, Celtra) exist but are not codegen-friendly and are out of scope.

## Artifact kind

`html` — a single self-contained AMP4ADS document.

## Validation

- **Install:** `npm install -g amphtml-validator`
- **Smoke:**
  ```bash
  cat > /tmp/ad.html <<'EOF'
  <!doctype html>
  <html ⚡4ads lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,minimum-scale=1">
    <script async src="https://cdn.ampproject.org/amp4ads-v0.js"></script>
    <style amp4ads-boilerplate>body{visibility:hidden}</style>
    <style amp-custom>h1{font-family:sans-serif;color:#1a73e8}</style>
  </head>
  <body>
    <h1>Hello Ad</h1>
  </body>
  </html>
  EOF
  amphtml-validator --html_format AMP4ADS /tmp/ad.html
  ```
- **Expect:** `/tmp/ad.html: PASS`. Runs fully headless on macOS. The validator needs network on first run to fetch the AMP4ADS ruleset (pin via `--validator_js` for offline/deterministic CI).

## Wrapper params

- `advertising-creative.title` (text) — headline text rendered in the ad body.
- `advertising-creative.subtext` (textarea) — supporting body copy.
- `advertising-creative.accent` (color) — accent color used in `amp-custom` styling.
- `advertising-creative.width` / `advertising-creative.height` (text) — ad slot dimensions.

## Component / explorer notes

Deliverable is a single self-contained `.html` conforming to the AMP4ADS subset:
- `⚡4ads` (or `amp4ads`) attribute on `<html>`
- `<meta charset>` as first head child
- mandatory `amp4ads-v0.js` runtime script
- mandatory `<style amp4ads-boilerplate>body{visibility:hidden}</style>`
- optional single `<style amp-custom>` for styling (no external CSS, no inline `style=` attrs, no custom JS)
- only the restricted AMP element set in `<body>` (`amp-img`, `amp-video`, `amp-carousel`, `amp-anim`, `amp-fit-text`, etc.)

Web Story ads are a superset adding required meta + CTA/ad-label UI. Output is fully deterministic given fixed assets (no randomness) — ideal for version control. Validation is a pure markup check; no headless browser needed. Visual snapshot via headless Chrome is optional QA, not part of the build contract.
