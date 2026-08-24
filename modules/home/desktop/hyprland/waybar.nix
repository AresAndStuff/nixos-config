{ pkgs, theme, ... }:
let
  alarmSound = "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga";

  pomodoro = pkgs.writeShellScriptBin "pomodoro" ''
    STATE_DIR="$XDG_RUNTIME_DIR/pomodoro"
    STATE_FILE="$STATE_DIR/state"
    LOCK_FILE="$STATE_DIR/lock"
    PGID_FILE="$STATE_DIR/alarm.pgid"
    DEFAULT=1500
    ALARM_SOUND="${alarmSound}"

    [ -e "$STATE_DIR" ] && [ ! -d "$STATE_DIR" ] && rm -f "$STATE_DIR"
    mkdir -p "$STATE_DIR"

    exec 9>"$LOCK_FILE"
    flock -x 9

    [ -f "$STATE_FILE" ] || echo "paused $DEFAULT" > "$STATE_FILE"

    read_state() {
      read STATUS VAL < "$STATE_FILE"
    }

    save() {
      echo "$STATUS $VAL" > "$STATE_FILE"
    }

    alarm_alive() {
      [ -f "$PGID_FILE" ] || return 1
      PGID=$(cat "$PGID_FILE" 2>/dev/null)
      [ -n "$PGID" ] || return 1
      kill -0 -- "-$PGID" 2>/dev/null
    }

    stop_alarm() {
      if [ -f "$PGID_FILE" ]; then
        PGID=$(cat "$PGID_FILE" 2>/dev/null)
        if [ -n "$PGID" ]; then
          kill -TERM -- "-$PGID" 2>/dev/null
          sleep 0.1
          kill -KILL -- "-$PGID" 2>/dev/null
        fi
        rm -f "$PGID_FILE"
      fi
      pkill -9 -f "paplay.*alarm-clock-elapsed" 2>/dev/null
      true
    }

    start_alarm() {
      if alarm_alive; then
        return
      fi
      notify-send "Timer finished" "Click to stop alarm" >/dev/null 2>&1
      
      setsid bash -c '
        exec 9>&-
        while true; do
          paplay "$1" >/dev/null 2>&1
          sleep 1
        done
      ' _ "$ALARM_SOUND" 9>&- </dev/null >/dev/null 2>&1 &
      DISOWN_PID=$!
      echo "$DISOWN_PID" > "$PGID_FILE"
      disown
    }

    case "$1" in
      toggle)
        read_state
        NOW=$(date +%s)
        case "$STATUS" in
          running)
            VAL=$((VAL - NOW))
            [ "$VAL" -lt 0 ] && VAL=0
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
          echo "{\"text\":\"󰹱 ALARM\",\"class\":\"finished\"}"
          exit
        fi

        if [ "$STATUS" = "running" ]; then
          REMAIN=$((VAL - NOW))
        else
          REMAIN=$VAL
        fi

        MIN=$((REMAIN/60))
        SEC=$((REMAIN%60))
        
        printf "{\"text\":\"󰀠 %02d:%02d\"}\n" "$MIN" "$SEC"
        ;;
    esac
  '';
in
{
  home.packages = [
    pomodoro
    pkgs.libnotify
    pkgs.pulseaudio
    pkgs.sound-theme-freedesktop
    pkgs.util-linux
  ];

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 40;
        spacing = 0;

        modules-left = [ "memory" "cpu" "custom/gpu" "hyprland/workspaces" "custom/pomodoro" ];
        modules-center = [ "wlr/taskbar" ];
        modules-right = [ "pulseaudio" "tray" "clock" "custom/power" ];

        "memory" = {
          format = "{:>3}% ";
          interval = 2;
        };

        "cpu" = {
          format = "{usage:>3}% ";
          interval = 2;
        };

        "custom/gpu" = {
          exec = "nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits";
          format = "{:>3}% 󰢮";
          return-type = "";
          interval = 2;
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{icon}";
          format-icons = {
            "active" = "●";
            "default" = "○";
            "urgent" = "◍";
          };
        }; 

        "custom/pomodoro" = {
          exec = "pomodoro";
          interval = 1;
          return-type = "json";
          on-click = "pomodoro toggle";
          on-click-right = "pomodoro reset";
          on-scroll-up = "pomodoro add";
          on-scroll-down = "pomodoro subtract";
        };

        "wlr/taskbar" = {
          format = "{icon}";
          all-outputs = true;
          icon-size = 20;
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close"; 
        };

        "pulseaudio" = {
          format = " {volume}%";
        };

        "tray" = {
          icon-size = 14;
          spacing = 6;
        };

        "clock" = {
          format = "{:%H:%M}";
          tooltip-format = "{:%Y-%m-%d}";
          on-click = "swaync-client -t -sw";
        };

        "custom/power" = {
          format = "⏻";
          on-click = "wlogout --buttons-per-row 4";
        };
      };
    };
    
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "${theme.font}", monospace;
        font-size: 15px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
      }

      #memory, #cpu, #custom-gpu, #workspaces, #custom-pomodoro,
      #taskbar, #pulseaudio, #tray, #clock, #custom-power {
        background-color: ${theme.surface};
        border-radius: 4px;
        padding: 2px 10px;
        margin: 4px 3px 6px;
        color: ${theme.text};
      }

      #workspaces button {
        padding: 0 4px;
        background: transparent;
        color: ${theme.muted};
      }

      #workspaces button.active {
        color: ${theme.accent};
      }

      #taskbar button {
        padding: 0 4px;
        background: transparent;
      }

      #taskbar button.active {
        background: ${theme.surfaceAlt};
        border-radius: 4px;
      }

      #custom-power {
        color: ${theme.red};
      }

      #custom-pomodoro.finished {
        animation: pomodoro-blink 1s steps(1) infinite;
      }

      @keyframes pomodoro-blink {
        50% {
          background-color: ${theme.red};
          color: ${theme.bg};
        }
      }
    '';
  };
}
