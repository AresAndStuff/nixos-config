# shellcheck shell=bash
# XF86AudioMute: pausiert was gerade läuft und merkt sich wen —
# beim nächsten Druck läuft genau das wieder an.

STATE_DIR="${XDG_RUNTIME_DIR}/playpause"
STATE_FILE="${STATE_DIR}/paused"

mkdir -p "$STATE_DIR"

exec 9>"${STATE_DIR}/lock"
flock -x 9

mapfile -t players < <(playerctl -l 2>/dev/null || true)

playing=()
for p in "${players[@]}"; do
  if [ "$(playerctl -p "$p" status 2>/dev/null || true)" = "Playing" ]; then
    playing+=("$p")
  fi
done

if [ "${#playing[@]}" -gt 0 ]; then
  printf '%s\n' "${playing[@]}" > "$STATE_FILE"
  for p in "${playing[@]}"; do
    playerctl -p "$p" pause 2>/dev/null || true
  done
elif [ -s "$STATE_FILE" ]; then
  mapfile -t previous < "$STATE_FILE"
  for p in "${previous[@]}"; do
    playerctl -p "$p" play 2>/dev/null || true
  done
  : > "$STATE_FILE"
else
  playerctl --player=mpd,vlc,%any play 2>/dev/null || true
fi
