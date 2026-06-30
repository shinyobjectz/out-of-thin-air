# lilypond (notation)

## Summary
LilyPond is a text-to-engraving compiler: you write notation in its `.ly`
domain-specific language and it produces publication-quality sheet music. The
canonical interface is the `lilypond` CLI, which compiles `.ly` source to PDF
(primary), plus SVG, PNG, PostScript, and MIDI. The primary deliverable is a
PDF score. No official Anthropic/Claude skill exists; the strongest
programmatic ecosystem is Python — Abjad as a first-class LilyPond file
builder, music21 as an exporter. Fully headless on macOS via Homebrew.

## Skills
| Name | URL | Type | License | Attribution |
|------|-----|------|---------|-------------|
| LilyPond Learning Manual (command-line setup) | https://lilypond.org/doc/v2.25/Documentation/learning/command-line-setup | official-docs | GFDL / public-domain docs | LilyPond project |
| LilyPond Notation Reference + Usage manuals | https://lilypond.org/manuals.html | official-docs | GFDL | LilyPond project |
| Abjad — Python API for building LilyPond files | https://github.com/Abjad/abjad | community repo | MIT | Abjad / Trevor Bača et al. |
| music21 LilyPond translate module | https://github.com/cuthbertLab/music21/blob/master/music21/lily/translate.py | community | BSD-3-Clause | cuthbertLab |

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| Native CLI | `brew install lilypond` (or `port install lilypond`) | `lilypond [--pdf\|--png\|--svg] file.ly` → `file.pdf`; `lilypond --version` to verify |
| Python (Abjad) | `pip install abjad` | build a Score/Staff in Python, then `abjad.persist.as_pdf(obj, 'out.pdf')` (shells out to the lilypond binary, 2.25.26+) |
| Python (music21) | `pip install music21` | `stream.write('lily.pdf')` (requires lilypond on PATH) |
| JS/TS | `npm i verovio` (alt) | no native JS engine — shell out to `lilypond` via child_process; Verovio is a separate WASM engraver for MEI/MusicXML |
| Docker | — | `docker run --rm -v $PWD:/work -w /work codello/lilypond lilypond file.ly` |

## Artifact kind
**pdf** — the default artifact PDF shell renders the score directly. MIDI is a
useful secondary output (emitted automatically when source has a `\midi`
block) worth surfacing for audio playback.

## Validation
- **install**: `brew install lilypond && lilypond --version`
- **smoke**: `printf '\\version "2.24.0"\n{ c4 d e f g1 }\n' > /tmp/test.ly && lilypond -o /tmp/test /tmp/test.ly`
- **expect**: exit 0; produces `/tmp/test.pdf` (single-staff score, c d e f then a whole-note g). Add `--png`/`--svg` for raster/vector. Fully headless on macOS — no display server.

## Wrapper params
- output format: `--pdf` / `--png` / `--svg` / `--ps`
- output basename: `-o`
- PNG resolution: `-dresolution=N`
- clean PDFs (no point-and-click): `-dno-point-and-click`
- `\version` header in source
- MIDI: emitted when source has a `\midi` block
- paper size / staff size set inside the `.ly` (`\paper`, `#(set-global-staff-size N)`), not via flags

## Component / explorer notes
Primary deliverable is a PDF. For an interactive explorer: side-by-side `.ly`
source + rendered score + a recompile button (LilyPond is a compile loop).
Surface MIDI as a secondary audio-playback output.
