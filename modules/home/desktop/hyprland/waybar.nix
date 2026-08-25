{ pkgs, theme, ... }:
let
  pomodoro = pkgs.writeShellApplication {
    name = "pomodoro";
    runtimeInputs = with pkgs; [
      coreutils
      libnotify
      procps
      pulseaudio
      util-linux
      bash
    ];
    runtimeEnv = {
      ALARM_SOUND =
        "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga";
    };
    text = builtins.readFile ./scripts/pomodoro.sh;
  };
in
{
  home.packages = [ pomodoro ];

  programs.waybar = {
    enable = true;
    systemd.enable = true;
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
