<!-- draft -->
# typography

Algorithmic type design — parametric glyphs / families.

## BUILD MATRIX

| tool | artifact kind | toolchains | primary skill (link) | official? | status | wrapper? | step? |
|---|---|---|---|---|---|---|---|
| fontParts | text (UFO) | Python, CLI (fontshell), Host apps (RoboFont/Glyphs/DrawBot) | [FontParts docs](https://fontparts.robotools.dev/en/stable/) | yes | ok | yes | yes |
| metafont | image (GF→PNG proof) | native CLI (web2c mf), native CLI vector (mf2pt1), Perl wrapper | [mf(1)](https://www.mankier.com/1/mf) | yes | ok | yes | yes |

## MULTI-TOOLCHAIN NOTES

- **fontParts** — Python (CPython 3.10–3.14, `from fontParts.world import RFont`), CLI (`fontshell`), and in-editor host APIs (RoboFont/Glyphs/DrawBot). No Go/JS-TS/React path. Strongest Python story in the category.
- **metafont** — native CLI only (web2c `mf` engine via MacTeX/TeX Live). Vector escape hatch through `mf2pt1` (needs fontforge + t1utils), plus a Perl wrapper from TeX Live. No Py/Go/JS-TS/React bindings.

Neither tool offers Go, JS-TS, or React. fontParts is the pick when you want a scriptable, programmatic glyph pipeline; metafont when you want Knuth-style parametric raster proofs.

## VALIDATION ORDER

1. **fontParts** — cheapest, most reliable. Pure pip into a venv (`python3 -m venv /tmp/fpv && /tmp/fpv/bin/pip install fontParts`), no system packages, smoke writes `/tmp/test.ufo` and prints `glyphs: 1`.
2. **metafont** — heavy install (`brew install --cask mactex-no-gui`, multi-GB TeX distribution). Validate second; smoke rasterizes `cmr10` to GF + TFM, proof PNG via gftodvi + dvipng.

## EXPLORER NEEDS

- **fontParts** — wants a glyph/specimen viewer beyond the default shell: UFO is a directory of GLIF/XML text, so a rendered SVG glyph specimen preview makes outlines legible. Default text shell suffices for inspecting GLIF source.
- **metafont** — wants an image proof viewer: artifact is a GF bitmap rendered to a PNG proof sheet; default artifact shell can display the PNG. No interactive explorer required.

No 3D/orbit or playable-canvas needs in this category — flat text + raster image previews cover it.

## DOSSIERS

- [fontParts](./fontparts.md)
- [metafont](./metafont.md)
