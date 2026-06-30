<!-- generated-draft -->
# notation

Sheet-music engraving — publication-quality scores from text.

## BUILD MATRIX

| tool | artifact kind | toolchains | primary skill | official? | status | wrapper? | step? |
|------|---------------|------------|---------------|-----------|--------|----------|-------|
| [lilypond](./lilypond.md) | pdf | Native CLI, Python (abjad, music21), JS/TS (verovio), Docker | [LilyPond Learning Manual (command-line setup)](./lilypond.md) | yes | ok | yes | yes |

## Multi-toolchain notes

- **lilypond** — broadest reach. Native CLI (`brew install lilypond → lilypond file.ly`) is the primary path. Python via `abjad` (`abjad.persist.as_pdf`) or `music21` (`stream.write('lily.pdf')`). JS/TS via `npm i verovio` or shelling out to the CLI. Docker via `codello/lilypond`. No Go or first-class React renderer; React/web embedding goes through verovio (SVG).

## VALIDATION ORDER

1. **lilypond** — `brew install lilypond && lilypond --version`; smoke: render a minimal `.ly` (`{ c4 d e f g1 }`) to `/tmp/test.pdf`, expect exit 0 and a single-staff PDF. Headless on macOS, no GUI deps, single reliable install — validate first.

## EXPLORER NEEDS

None beyond the default artifact shell. PDF scores render in the standard PDF viewer; optional MIDI playback (gated on `notation.midi` toggle) plays through a standard audio sink. No 3D/orbit/playable-canvas explorer required.

## Dossiers

- [lilypond](./lilypond.md)
