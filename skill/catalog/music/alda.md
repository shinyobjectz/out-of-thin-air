<!-- generated draft — needs validation -->
# alda (music)

## Summary
Alda is a text-based music programming language for musicians. You write notes,
chords, tempo, and instrument parts as plain text and the CLI plays them back or
exports MIDI. Architecture: a Go client (`alda`) plus a Kotlin/JVM player (the
sound engine requires Java). The primary deliverable is a Standard MIDI File
(audio when played). Toolchains are wrapper libraries that shell out to the
`alda` binary; there is no native non-CLI runtime. No Anthropic/Claude SKILL.md
exists for this tool.

## Skills (attributed references)
| Skill | Type | URL | Official | License | Attribution |
|---|---|---|---|---|---|
| Official Alda docs (index, tutorial, install) | official-docs | https://alda.io/docs/ | yes | EPL-2.0 (repo) | alda-lang / Dave Yarwood |
| How to implement an Alda library for your language | official-docs | https://github.com/alda-lang/alda/blob/master/doc/implementing-an-alda-library.md | yes | EPL-2.0 | Dave Yarwood |
| alda-lang/alda README + doc/ (no SKILL.md / llms.txt) | repo | https://github.com/alda-lang/alda | yes | EPL-2.0 | alda-lang |

## Toolchains
| lang | install | invoke |
|---|---|---|
| native CLI (Go client + Kotlin/JVM player, needs Java) | `brew install alda` (macOS) or download from https://alda.io/install/ | `alda export -c "piano: c d e f g" -o out.mid`; `alda play -c "..."`; `alda repl`; `alda doctor` |
| Ruby (alda-rb, community) | `gem install alda-rb` | Ruby DSL generates Alda source, shells out to `alda` — github.com/UlyssesZh/alda-rb |
| Clojure (alda-clj, by Alda's author) | add dep `[io.djy/alda-clj "x.y.z"]` (Leiningen/deps.edn) | Generates + plays Alda code via the binary — github.com/daveyarwood/alda-clj |
| Python (alda-python, community) | clone github.com/nvitucci/alda-python (not on PyPI) | Python client wrapping the CLI |

## Artifact kind
**audio** — primary deliverable is a MIDI file (renderable to audio when played).

## Validation
- **install**: `brew install alda && java -version` — the player needs Java; install
  OpenJDK from Adoptium if missing.
- **smoke**: `alda export -c "piano: c d e f g a b > c" -o /tmp/alda-smoke.mid && ls -la /tmp/alda-smoke.mid`
- **expect**: a valid Standard MIDI File (~hundreds of bytes) at
  `/tmp/alda-smoke.mid`. `alda export` works headless (no audio device);
  `alda play` requires audio output. Run `alda doctor` to confirm client+player
  health.

## Wrapper params
- `code` (-c inline Alda) vs `file` (-f path) — source of music.
- export output path/format (`-o`, MIDI).
- tempo — set via `(tempo! N)` in source.
- instrument — General MIDI names (piano, trumpet, ...).
- player host/port for playback.
- surface `alda doctor` as health check; Java presence is a prerequisite gate.

## Component / explorer notes
Output is a MIDI file, not directly renderable in the default artifact shell.
A richer explorer would convert MIDI to audio (e.g. fluidsynth + a SoundFont to
WAV/MP3) for an `<audio>` element, optionally with a piano-roll/notation
visualization. The `.alda` source itself is plain text and shows fine as a code
block.
