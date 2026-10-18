{
  config,
  pkgs,
  theme,
  ...
}:

let
  swaync-client = "${config.services.swaync.package}/bin/swaync-client";
  toggleQuickSettings = "${swaync-client} -t -sw";

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
      ALARM_SOUND = "${pkgs.sound-theme-freedesktop}/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga";
    };
    text = builtins.readFile ./scripts/pomodoro.sh;
  };
in
{
  home.packages = [
    pomodoro
    pkgs.networkmanagerapplet
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 0;

        modules-left = [
          "hyprland/workspaces"
          "custom/pomodoro"
        ];
        modules-center = [ "group/datetime" ];
        modules-right = [
          "tray"
          "group/system"
        ];

        # Active workspace is a wide pill, the others are dots
        "hyprland/workspaces" = {
          format = "";
          disable-scroll = true;
          all-outputs = true;
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

        # center: date + unread-notification dot
        "group/datetime" = {
          orientation = "horizontal";
          modules = [
            "clock"
            "custom/notification"
          ];
        };

        "clock" = {
          format = "{:%b %d   %H:%M}";
          tooltip = false;
        };

        # dot next to the clock: shows while there are notifications
        "custom/notification" = {
          exec = "${swaync-client} -swb";
          return-type = "json";
          format = "{icon}";
          format-icons = {
            notification = "●";
            dnd-notification = "●";
            inhibited-notification = "●";
            dnd-inhibited-notification = "●";
            none = "";
            dnd-none = "";
            inhibited-none = "";
            dnd-inhibited-none = "";
          };
          escape = true;
          tooltip = false;
          on-click = toggleQuickSettings;
        };

        # ── right: one pill that opens quick settings ───────────────────
        "group/system" = {
          orientation = "horizontal";
          modules = [
            "bluetooth"
            "pulseaudio"
            "custom/power"
          ];
        };

        # Only visible while a device is connected, as in GNOME
        "bluetooth" = {
          format = "";
          format-connected = "󰂱";
          format-connected-battery = "󰂱";
          tooltip-format-connected = "{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}";
          tooltip-format-enumerate-connected-battery = "{device_alias}  {device_battery_percentage}%";
          on-click = toggleQuickSettings;
        };

        "pulseaudio" = {
          format = "{icon}";
          format-muted = "󰝟";
          format-icons.default = [
            "󰕿"
            "󰖀"
            "󰕾"
          ];
          tooltip-format = "{desc}  {volume}%";
          scroll-step = 5;
          on-click = toggleQuickSettings;
        };

        "custom/power" = {
          format = "󰐥";
          tooltip = false;
          on-click = toggleQuickSettings;
        };

        "tray" = {
          icon-size = 16;
          spacing = 10;
        };
      };
    };

    style = ''
      * {
        border: none;
        border-radius: 0;
        box-shadow: none;
        text-shadow: none;
        font-family: "Inter", "Symbols Nerd Font";
        font-size: 14px;
        font-weight: bold;
        min-height: 0;
      }

      window#waybar {
        background: #000000;
        color: #ffffff;
      }

      tooltip {
        background: ${theme.surface};
        border-radius: 8px;
      }
      tooltip label {
        color: ${theme.text};
        font-weight: normal;
      }

      /* the pills */
      #workspaces, #custom-pomodoro, #datetime, #tray, #system {
        margin: 3px 2px;
        padding: 0 12px;
        border-radius: 99px;
        background: transparent;
        transition: background-color 150ms ease;
      }

      #tray {
        padding: 0;
      }

      #workspaces:hover, #custom-pomodoro:hover, #datetime:hover, #system:hover {
        background: rgba(255, 255, 255, 0.15);
      }

      #clock, #custom-notification, #network, #bluetooth, #pulseaudio, #custom-power {
        padding: 0;
        background: transparent;
        color: #ffffff;
      }
      #clock { padding: 0 2px; }
      #custom-notification { padding-left: 8px; font-size: 9px; }
      #network, #bluetooth, #pulseaudio { padding-right: 14px; }
      #network, #bluetooth, #pulseaudio, #custom-power { font-size: 16px; }

      /* GNOME's workspace indicator */
      #workspaces button {
        min-width: 8px;
        min-height: 8px;
        margin: 9px 3px;
        padding: 0;
        border-radius: 99px;
        background: rgba(255, 255, 255, 0.45);
        transition: min-width 200ms ease, background-color 200ms ease;
      }
      /* the empty label still has a line height and would make the dot tall */
      #workspaces button label {
        font-size: 1px;
        padding: 0;
      }
      #workspaces button.active {
        min-width: 34px;
        background: #ffffff;
      }
      #workspaces button.urgent {
        background: ${theme.red};
      }
      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.8);
      }

      #custom-pomodoro.finished {
        animation: pomodoro-blink 1s steps(1) infinite;
      }
      @keyframes pomodoro-blink {
        50% {
          background-color: ${theme.red};
          color: #000000;
        }
      }
    '';
  };
}
