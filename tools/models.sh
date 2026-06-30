#!/usr/bin/env bash
# List / check / download HF models from media/models.work
set -euo pipefail

PROJECT="$(cd "$(dirname "$0")/.." && pwd)"
TOOLS="$(cd "$(dirname "$0")" && pwd)"
MODELS="$PROJECT/media/models.work"
HARDWARE="$TOOLS/hardware.sh"

usage() {
  cat <<EOF
Usage:
  models.sh list [task]     # tts | music | video-gen | stt
  models.sh check <id>      # runnable on this machine?
  models.sh download <id> [out_dir]

Models are defined in media/models.work — no API keys required for public repos.
EOF
}

parse_models() {
  awk '
    /^model :/ {
      gsub(/^model :|:.*$/, "", $0); gsub(/ do$/, "", $0); id=$0
      task=repo=format=min_ram=min_vram=runtime=notes=""
    }
    /^  task:/ { gsub(/^  task: /, ""); task=$0 }
    /^  repo:/ { gsub(/^  repo: /, ""); repo=$0 }
    /^  format:/ { gsub(/^  format: /, ""); format=$0 }
    /^  min_ram_gb:/ { gsub(/^  min_ram_gb: /, ""); min_ram=$0 }
    /^  min_vram_gb:/ { gsub(/^  min_vram_gb: /, ""); min_vram=$0 }
    /^  runtime:/ { gsub(/^  runtime: /, ""); runtime=$0 }
    /^  notes:/ { gsub(/^  notes: /, ""); notes=$0 }
    /^end$/ && id != "" {
      print id "\t" task "\t" repo "\t" format "\t" min_ram "\t" min_vram "\t" runtime "\t" notes
      id=""
    }
  ' "$MODELS"
}

get_field() {
  local id="$1" field="$2" line
  line="$(parse_models | awk -F'\t' -v id="$id" '$1==id {print; exit}')"
  [[ -n "$line" ]] || return 1
  case "$field" in
    task) echo "$line" | cut -f2 ;;
    repo) echo "$line" | cut -f3 ;;
    min_ram) echo "$line" | cut -f5 ;;
    min_vram) echo "$line" | cut -f6 ;;
    runtime) echo "$line" | cut -f7 ;;
    notes) echo "$line" | cut -f8 ;;
  esac
}

hw_json() { bash "$HARDWARE"; }

cmd_list() {
  local filter="${1:-}"
  local hw ram vram
  hw="$(hw_json)"
  ram="$(echo "$hw" | python3 -c 'import json,sys; print(json.load(sys.stdin)["ram_gb"])')"
  vram="$(echo "$hw" | python3 -c 'import json,sys; print(json.load(sys.stdin)["vram_gb"])')"
  printf "%-22s %-10s %-8s %-8s %s\n" "ID" "TASK" "RAM" "VRAM" "REPO"
  while IFS=$'\t' read -r id task repo _ min_ram min_vram _ notes; do
    [[ -z "$id" ]] && continue
    [[ -n "$filter" && "$task" != "$filter" ]] && continue
    local status="ok"
    if (( ram < min_ram )); then status="defer:ram"; fi
    if (( min_vram > 0 && vram < min_vram )); then status="defer:vram"; fi
    printf "%-22s %-10s %4s/%sG %4s/%sG %s (%s)\n" "$id" "$task" "$ram" "$min_ram" "$vram" "$min_vram" "$repo" "$status"
  done < <(parse_models)
}

cmd_check() {
  local id="$1"
  local min_ram min_vram repo notes
  min_ram="$(get_field "$id" min_ram)" || { echo "Unknown model: $id"; exit 1; }
  min_vram="$(get_field "$id" min_vram)"
  repo="$(get_field "$id" repo)"
  notes="$(get_field "$id" notes)"
  local hw ram vram gpu
  hw="$(hw_json)"
  ram="$(echo "$hw" | python3 -c 'import json,sys; print(json.load(sys.stdin)["ram_gb"])')"
  vram="$(echo "$hw" | python3 -c 'import json,sys; print(json.load(sys.stdin)["vram_gb"])')"
  gpu="$(echo "$hw" | python3 -c 'import json,sys; print(json.load(sys.stdin)["gpu"])')"
  local ok=true reason=""
  if (( ram < min_ram )); then ok=false; reason="Need ${min_ram}GB RAM, have ${ram}GB"; fi
  if (( min_vram > 0 && vram < min_vram )); then
    ok=false
    reason="${reason:+$reason; }Need ${min_vram}GB VRAM, have ${vram}GB (${gpu})"
  fi
  if $ok; then
    echo "OK: $id ($repo) — $notes"
    exit 0
  else
    echo "DEFER: $id — $reason"
    exit 2
  fi
}

cmd_download() {
  local id="$1"
  local out="${2:-$PROJECT/cli/sessions/_models/$id}"
  cmd_check "$id" || {
    echo "Download skipped — hardware check failed."
    exit 2
  }
  local repo
  repo="$(get_field "$id" repo)"
  mkdir -p "$out"
  local py="python3"
  local venv="$PROJECT/.venv-tts/bin/python"
  [[ -x "$venv" ]] && py="$venv"
  if command -v huggingface-cli >/dev/null 2>&1 && [[ "$py" == "python3" ]]; then
    huggingface-cli download "$repo" --local-dir "$out"
  elif "$py" -c "import huggingface_hub" 2>/dev/null; then
    "$py" - <<PY
from huggingface_hub import snapshot_download
snapshot_download(repo_id="${repo}", local_dir="${out}")
PY
  else
    echo "Run: oota tts-setup   # then retry download"
    exit 1
  fi
  echo "Downloaded $repo → $out"
}

case "${1:-}" in
  list) cmd_list "${2:-}" ;;
  check) cmd_check "${2:?model id required}" ;;
  download) cmd_download "${2:?model id required}" "${3:-}" ;;
  *) usage; exit 1 ;;
esac
