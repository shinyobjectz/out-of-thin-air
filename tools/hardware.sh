#!/usr/bin/env bash
# Probe local hardware for code-as local model eligibility.
# Outputs JSON: ram_gb, gpu, vram_gb, runtimes[], defer_reason (optional)
set -euo pipefail

ram_bytes=0
gpu="none"
vram_gb=0
runtimes=()

if [[ "$(uname -s)" == "Darwin" ]]; then
  ram_bytes="$(sysctl -n hw.memsize 2>/dev/null || echo 0)"
  chip="$(sysctl -n machdep.cpu.brand_string 2>/dev/null || true)"
  if [[ "$chip" == *"Apple"* ]]; then
    gpu="apple_mps"
    runtimes+=("onnx" "transformers-mps" "gguf")
  fi
elif [[ -f /proc/meminfo ]]; then
  ram_bytes="$(awk '/MemTotal/ {print $2 * 1024}' /proc/meminfo)"
fi

if command -v nvidia-smi >/dev/null 2>&1; then
  gpu="cuda"
  vram_mb="$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits 2>/dev/null | head -1 | tr -d ' ')"
  if [[ -n "${vram_mb:-}" && "$vram_mb" =~ ^[0-9]+$ ]]; then
    vram_gb=$(( (vram_mb + 1023) / 1024 ))
  fi
  runtimes+=("onnx" "transformers-cuda" "gguf" "diffusers")
fi

if [[ ${#runtimes[@]} -eq 0 ]]; then
  runtimes+=("onnx" "transformers-cpu" "gguf")
fi

ram_gb=$(( (ram_bytes + 1073741823) / 1073741824 ))

# Dedupe runtimes
unique_runtimes="$(printf '%s\n' "${runtimes[@]}" | awk '!seen[$0]++' | paste -sd, -)"

python3 - <<PY
import json
print(json.dumps({
  "ram_gb": ${ram_gb},
  "gpu": "${gpu}",
  "vram_gb": ${vram_gb},
  "runtimes": "${unique_runtimes}".split(",") if "${unique_runtimes}" else [],
  "platform": "$(uname -s)",
}, indent=2))
PY
