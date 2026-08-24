# shellcheck shell=bash
# Waybar-Pomodoro. Ohne Argument = aktuellen Stand als JSON ausgeben
# (1x/Sekunde), die Subkommandos kommen aus den Klick/Scroll-Bindings.
# State liegt in XDG_RUNTIME_DIR, überlebt also keinen Reboot.

: "${ALARM_SOUND:?}"

STATE_DIR="${XDG_RUNTIME_DIR}/pomodoro"
STATE_FILE="${STATE_DIR}/state"
LOCK_FILE="${STATE_DIR}/lock"
PGID_FILE="${STATE_DIR}/alarm.pgid"
DEFAULT=1500

if [ -e "$STATE_DIR" ] && [ ! -d "$STATE_DIR" ]; then
  rm -f "$STATE_DIR"
fi
mkdir -p "$STATE_DIR"

exec 9>"$LOCK_FILE"
flock -x 9

[ -f "$STATE_FILE" ] || echo "paused $DEFAULT" > "$STATE_FILE"

read_state() {
  STATUS=paused
  VAL=$DEFAULT
  read -r STATUS VAL < "$STATE_FILE" || true
}

save() {
  echo "$STATUS $VAL" > "$STATE_FILE"
}

alarm_alive() {
  [ -f "$PGID_FILE" ] || return 1
  PGID=$(cat "$PGID_FILE" 2>/dev/null) || return 1
  [ -n "$PGID" ] || return 1
  kill -0 -- "-$PGID" 2>/dev/null
}

stop_alarm() {
  if [ -f "$PGID_FILE" ]; then
    PGID=$(cat "$PGID_FILE" 2>/dev/null) || PGID=""
    if [ -n "$PGID" ]; then
      kill -TERM -- "-$PGID" 2>/dev/null || true
      sleep 0.1
      kill -KILL -- "-$PGID" 2>/dev/null || true
    fi
    rm -f "$PGID_FILE"
  fi
  pkill -9 -f "paplay.*alarm-clock-elapsed" 2>/dev/null || true
}

start_alarm() {
  if alarm_alive; then
    return
  fi
  notify-send "Timer finished" "Click to stop alarm" >/dev/null 2>&1 || true

  # $1 wird von der bash -c Subshell aufgelöst, nicht hier — single quotes
  # sind Absicht.
  # shellcheck disable=SC2016
  setsid bash -c '
    exec 9>&-
    while true; do
      paplay "$1" >/dev/null 2>&1
      sleep 1
    done
  ' _ "$ALARM_SOUND" 9>&- </dev/null >/dev/null 2>&1 &
  echo "$!" > "$PGID_FILE"
  disown
}

case "${1:-}" in
  toggle)
    read_state
    NOW=$(date +%s)
    case "$STATUS" in
      running)
        VAL=$((VAL - NOW))
        if [ "$VAL" -lt 0 ]; then VAL=0; fi
        STATUS=paused
        ;;
      alarm)
        stop_alarm
        STATUS=paused
        VAL=$DEFAULT
        ;;
      *)
        VAL=$((NOW + VAL))
        STATUS=running
        ;;
    esac
    save
    ;;

  reset)
    stop_alarm
    STATUS=paused
    VAL=$DEFAULT
    save
    ;;

  add)
    read_state
    VAL=$((VAL + 60))
    save
    ;;

  subtract)
    read_state
    VAL=$((VAL - 60))
    if [ "$STATUS" = "paused" ] && [ "$VAL" -lt 60 ]; then
      VAL=60
    fi
    save
    ;;

  *)
    read_state
    NOW=$(date +%s)

    if [ "$STATUS" = "running" ]; then
      REMAIN=$((VAL - NOW))
      if [ "$REMAIN" -le 0 ]; then
        STATUS=alarm
        VAL=0
        save
        start_alarm
      fi
    fi

    if [ "$STATUS" = "alarm" ]; then
      echo '{"text":"󰹱 ALARM","class":"finished"}'
      exit
    fi

    if [ "$STATUS" = "running" ]; then
      REMAIN=$((VAL - NOW))
    else
      REMAIN=$VAL
    fi

    printf '{"text":"󰀠 %02d:%02d"}\n' "$((REMAIN / 60))" "$((REMAIN % 60))"
    ;;
esac
