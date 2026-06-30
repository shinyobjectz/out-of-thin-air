# SuperCollider (music)

## Summary
SuperCollider is a server/language audio synthesis platform: `scsynth`/`supernova` (the realtime + NRT DSP server) driven by `sclang` (an interpreted, object-oriented language) over OSC. Code-as-music: write `SynthDef`s and `Pattern`s/`Score`s in sclang, then play in realtime or render deterministically offline (NRT) to a sound file. The primary deliverable is **audio** (AIFF/WAV/FLAC). It is also the synthesis backend for TidalCycles (Haskell), Sonic Pi (Ruby), Overtone (Clojure), and FoxDot/Renardo (Python). Headless rendering works on macOS via the NRT command-line switch (`-N`) — no GUI or audio device required. No official Anthropic/Claude SKILL.md exists; this dossier relies on official help docs plus community curated lists.

## Skills
| Name | Type | URL | Official | License | Attribution |
|------|------|-----|----------|---------|-------------|
| SuperCollider official docs — Non-Realtime Synthesis guide | official-docs | https://doc.sccode.org/Guides/Non-Realtime-Synthesis.html | yes | GPLv3 (project) | SuperCollider project |
| awesome-supercollider (curated list, ARCHIVED) | community | https://github.com/madskjeldgaard/awesome-supercollider | no | see repo | Mads Kjeldgaard |
| Supriya docs (Python API; NRT/score patterns) | repo | https://github.com/supriya-project/supriya | no | MIT | Joséphine Wolf Oberholtzer / supriya-project |
| howto_co34pt_liveCode (live-coding tutorial book) | community | https://theseanco.github.io/howto_co34pt_liveCode/ | no | see repo | theseanco |

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| Native (sclang) | `brew install --cask supercollider` then `ln -sf /Applications/SuperCollider.app/Contents/MacOS/sclang /usr/local/bin/sclang` | `sclang script.scd` (NRT render via `Score.recordNRT` or `scsynth -N`) |
| Python | `pip install supriya` (needs SuperCollider installed) | build SynthDefs + NRT `Session` in Python, render to disk |
| Python (lightweight) | `pip install supercollider` (ideoforms/python-supercollider) | thin OSC control of a running scsynth — realtime only, not a renderer |
| Python (sclang port) | `pip install sc3` (smrg-lm/sc3) | sclang class library/patterns ported to Python incl. NRT scoring |
| Any (OSC) | `pip install python-osc` (or any OSC lib) | drive `scsynth` over OSC/UDP from any language |
| Haskell | `cabal install tidal` + SuperDirt quark | TidalCycles pattern frontend; SC/SuperDirt is the audio engine |
| Ruby | `brew install --cask sonic-pi` | education-focused live coding; bundles its own SC backend |
| Clojure | Leiningen dep `[overtone "0.10.x"]` | Clojure client that boots/embeds scsynth |

## Artifact kind
**audio** — primary deliverable is a rendered sound file (AIFF/WAV/FLAC). Source `.scd` (SynthDef + Score) shown alongside as text.

## Validation
**Install**
```bash
brew install --cask supercollider && ln -sf /Applications/SuperCollider.app/Contents/MacOS/sclang /usr/local/bin/sclang
```
**Smoke** — render a 2s stereo 440Hz perc tone offline (NRT), no audio device:
```bash
cat > /tmp/render.scd <<'EOF'
(
var score = Score([
  [0.0, ['/d_recv', SynthDef(\beep, { |out=0|
      Out.ar(out, SinOsc.ar(440) * EnvGen.kr(Env.perc(0.01,1.8), doneAction:2) * 0.3 ! 2);
  }).asBytes]],
  [0.0, ['/s_new', \beep, 1000, 0, 0]],
  [2.0, ['/c_set', 0, 0]]
]);
score.recordNRT(nil, "/tmp/out.aiff".standardizePath, sampleRate:44100, headerFormat:"AIFF", sampleFormat:"int16", options:ServerOptions.new.numOutputBusChannels_(2), duration:2.0, action:{ 0.exit });
)
EOF
sclang /tmp/render.scd
```
**Expect** — scsynth runs in NRT mode (no audio device touched) and writes `/tmp/out.aiff`, a ~2s stereo AIFF. Verify: `ls -l /tmp/out.aiff && afinfo /tmp/out.aiff` (or `soxi`). sclang exits via `0.exit`.

## Wrapper params
- `music.title` — label/title (text)
- `music.format` — header format: AIFF / WAV / FLAC (select)
- `music.sampleformat` — int16 / int24 / float (select)
- `music.samplerate` — 44100 / 48000 (select)
- `music.duration` — render length in seconds (range)
- `music.channels` — mono(1) / stereo(2) (select)

Plus the user's sclang SynthDef/Score source (bound to `src/render.scd`). For realtime/live-coding mode expose server options (block size, sample rate, num buses) and an OSC port; for deterministic headless renders always run the server with `-N` (NRT).

## Component / explorer notes
Primary output is an audio file the default artifact shell plays with an `<audio>` element / waveform. A richer explorer (waveform + spectrogram + transport scrubber) is nice-to-have but not required. Show source `.scd` and the SynthDef/Score alongside as text.
