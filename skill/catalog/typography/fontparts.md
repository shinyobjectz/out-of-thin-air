# FontParts

## Summary
FontParts is an application-independent Python API for programmatically creating
and editing the parts of fonts (font, glyph, contour, point, anchor, component)
during type design. It is the successor to RoboFab and implements the same object
model that RoboFont, Glyphs, and DrawBot expose, but runs standalone on top of
`defcon` + `fontTools`. The primary deliverable is a **UFO source** — a directory
of XML/plist (GLIF) text files — with glyph outlines drawn via segment/point pens.
FontParts is a font-*source* generator, not a renderer: you script outlines and
`font.info`, then `font.save('x.ufo')`, and compile to OTF/TTF separately with
`fontmake`/`fontTools`. Ideal for algorithmic / parametric glyph families.

## Skills (attributed references)
| Skill | Type | URL | Official | License | Attribution |
|---|---|---|---|---|---|
| FontParts official documentation | official-docs | https://fontparts.robotools.dev/en/stable/ | yes | MIT (project) | robotools / FontParts authors |
| FontParts GitHub (source + fontshell CLI) | repo | https://github.com/robotools/fontParts | yes | MIT | robotools org |
| RoboFont FontParts API reference (richest examples) | official-docs | https://robofont.com/documentation/reference/fontparts/ | community | docs (proprietary site, free to read) | RoboFont / Type Supply |

## Toolchains
| lang | install | invoke |
|---|---|---|
| Python (CPython 3.10–3.14) | `pip install fontParts` | `from fontParts.world import RFont; f=RFont(showInterface=False); ...; f.save('x.ufo')` |
| CLI (fontshell) | `pip install fontParts` | `fontshell` (interactive console implementation of the object model) |
| Python (host apps: RoboFont / Glyphs / DrawBot) | bundled with the app | same `fontParts.world` API (`CurrentFont`, `AllFonts`, `RGlyph`) embedded in-editor |

Primary and effectively only driver is the Python API; it pulls in `defcon` + `fontTools`.

## Artifact kind
**text** — the primary deliverable is a UFO font source, a bundle of XML/plist
(GLIF) text files. No video/audio/3d. Glyph previews can be rendered to SVG via a
pen (secondary preview kind), but the native, primary output is editable
text-based source.

## Validation
- **install:** `python3 -m venv /tmp/fpv && /tmp/fpv/bin/pip install fontParts`
- **smoke:**
  ```bash
  /tmp/fpv/bin/python -c "from fontParts.world import RFont; f=RFont(showInterface=False); f.info.unitsPerEm=1000; f.info.ascender=750; f.info.descender=-250; g=f.newGlyph('A'); g.width=600; p=g.getPen(); p.moveTo((50,0)); p.lineTo((300,700)); p.lineTo((550,0)); p.closePath(); f.save('/tmp/test.ufo'); print('glyphs:', len(f))" && ls /tmp/test.ufo/glyphs/
  ```
- **expect:** Prints `glyphs: 1` and creates `/tmp/test.ufo/` containing
  `metainfo.plist`, `fontinfo.plist`, and `glyphs/A_.glif`. Fully headless on macOS
  (`showInterface=False`, no GUI). Compile to OTF later with:
  `pip install fontmake && fontmake -u /tmp/test.ufo -o otf`.

## Wrapper params
- glyph name + unicode
- advance width
- font.info metrics: `unitsPerEm`, `ascender`, `descender`, `xHeight`, `capHeight`
- the pen drawing program (moveTo/lineTo/curveTo/closePath point lists) **or** a
  parametric generator (stem weight, contrast, width, slant) that emits contours
- output path for `.ufo`
- for families: a designspace/axis list + per-master values
- downstream compile target (otf/ttf via fontmake) — optional

## Component / explorer notes
The default artifact shell will not meaningfully render a `.ufo` (it's a directory
of XML/GLIF files). A useful explorer would (a) draw each glyph's contours to inline
SVG via a pen for a visual specimen sheet, and (b) show `font.info` metrics. For
parametric work the rich ideal is an interactive slider explorer (axis values →
regenerated outlines → live SVG specimen); minimum viable is a static SVG glyph grid
plus the raw GLIF text.
