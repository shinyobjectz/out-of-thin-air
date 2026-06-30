<!-- generated draft — needs validation -->
# sonic-pi

## Summary
Sonic Pi is a Ruby-based live-coding music environment built on the SuperCollider synthesis engine. You write Sonic Pi code (a Ruby DSL: `play`, `sample`, `live_loop`, `synth`, `use_bpm`, etc.) and the SuperCollider backend renders it to audio in real time. There is no built-in one-shot "render this file to WAV" CLI; headless use means starting the Sonic Pi server (or its bundled SuperCollider), pushing code to it over OSC (UDP port 4560), and capturing the audio output to a WAV via the `record` command. Recording is **wall-clock real-time capture**, not offline render, so you must run for the full musical duration. On a headless box you need a real or virtual/dummy audio sink (e.g. BlackHole on macOS) for the recorder to capture output. Sonic Pi v4+ requires a per-session auth token (auto-discovered from the Sonic Pi logs) for programmatic OSC control. Confidence: medium.

## Skills (attributed references)
| Name | Type | URL | Official | License | Attribution |
|------|------|-----|----------|---------|-------------|
| Sonic Pi official tutorial / docs | official-docs | https://sonic-pi.net/tutorial.html | yes | MIT (code) / CC (docs) | Sam Aaron / sonic-pi-net |
| Sonic Pi OSC tutorial (12.1 Receiving OSC) | official-docs | https://github.com/sonic-pi-net/sonic-pi/blob/dev/etc/doc/tutorial/12.1-Receiving-OSC.md | yes | MIT | sonic-pi-net |
| Sonic Pi Internals — GUI Ruby API (wiki) | official-docs | https://github.com/sonic-pi-net/sonic-pi/wiki/Sonic-Pi-Internals----GUI-Ruby-API | yes | MIT | sonic-pi-net |
| No Anthropic/Claude SKILL.md or llms.txt found for Sonic Pi | community | https://github.com/sonic-pi-net/sonic-pi | no | n/a | none located |

## Toolchains
| lang | install | invoke |
|------|---------|--------|
| Rust / native CLI (sonic-pi-tool, lpil) | `cargo install sonic_pi_tool` or `brew install sonic-pi-tool` | `sonic-pi-tool start-server`; `sonic-pi-tool eval-file song.rb`; `sonic-pi-tool record /tmp/out.wav` then `sonic-pi-tool stop` |
| Python (sonic-pi-tool.py, emlyn) | `pip install sonic-pi-tool.py` | `sonic-pi-tool run/eval-file/record/logs/stop` — handles v4+ auth token discovery from logs |
| Python (python-sonic, gkvoelkl) | `pip install python-sonic` | Pythonic API mirroring DSL (`play`, `sleep`, `synth`, `sample`); sends OSC to running instance |
| Python (generic OSC) | `pip install python-osc` | `SimpleUDPClient('127.0.0.1',4560).send_message('/run-code',[token, code])` — token from logs on v4+ |
| Ruby (sonic-pi-cli, Widdershin) | `gem install sonic_pi` | `sonic_pi 'play 70'` pipes code to running server over OSC (pre-v4 era) |
| JS/TS, Go, any | `npm i osc` (JS) / any OSC lib | Raw OSC UDP to port 4560, same path as the Python OSC route; no first-party SDK |

## Artifact kind
**audio** (WAV). The authored artifact is the Sonic Pi `.rb` source; the WAV is its real-time render.

## Validation
- **install:** `brew install --cask sonic-pi && cargo install sonic_pi_tool` (macOS; or `brew install sonic-pi-tool`)
- **smoke:**
  ```bash
  sonic-pi-tool start-server &   # wait for boot
  sleep 20
  sonic-pi-tool record /tmp/sp.wav
  sonic-pi-tool eval 'use_bpm 120; 4.times do; play 60; sleep 0.5; end'
  sleep 3
  sonic-pi-tool stop             # finalizes /tmp/sp.wav
  ```
- **expect:** `/tmp/sp.wav` with ~2s of four piano-ish notes. Recording is real-time capture — wait while it plays. On a truly headless macOS box you need an audio sink (e.g. BlackHole) or SuperCollider must otherwise produce output for the recorder to capture.

## Wrapper params
- input `.rb` source code (the authored artifact)
- BPM / seed
- record duration (real-time capture — must specify how long to run)
- output WAV path
- sample rate
- server bootstrap step + v4+ auth token (auto-discovered from logs) — the main breakage point for programmatic control

## Component / explorer notes
Default artifact shell can play a WAV with a basic `<audio>` element — adequate. A richer explorer (waveform + the source Sonic Pi `.rb` code side-by-side, transport controls) fits better since the code is the authored artifact and the audio is the render.
