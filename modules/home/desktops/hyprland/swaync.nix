{
  config,
  lib,
  pkgs,
  theme,
  ...
}:

# The control center doubles as GNOME's quick-settings menu; waybar's system
# pill (network, volume, power) opens it.
let
  nmcli = "${pkgs.networkmanager}/bin/nmcli";
  bluetoothctl = "${pkgs.bluez}/bin/bluetoothctl";
  swaync-client = "${config.services.swaync.package}/bin/swaync-client";
  hyprlock = lib.getExe config.programs.hyprlock.package;

  # A quick-settings tile. swaync flips the button, then runs `on` or `off`
  # with SWAYNC_TOGGLE_STATE set; `state` re-reads it whenever the panel opens.
  toggle =
    {
      label,
      on,
      off,
      state,
    }:
    {
      inherit label;
      type = "toggle";
      command = toString (
        pkgs.writeShellScript "swaync-toggle" ''
          if [ "$SWAYNC_TOGGLE_STATE" = true ]; then ${on}; else ${off}; fi
        ''
      );
      update-command = toString (
        pkgs.writeShellScript "swaync-toggle-state" ''
          if ${state}; then echo true; else echo false; fi
        ''
      );
    };

  # Close the panel first, so it isn't in the way (screenshots, lock screen).
  # swaync runs commands as `/bin/sh -c "<command>"`, so anything with quotes
  # has to live in a script.
  closeAnd =
    name: cmd:
    toString (
      pkgs.writeShellScript "swaync-${name}" ''
        ${swaync-client} -cp
        ${cmd}
      ''
    );

  screenshot = ''
    sleep 0.3
    ${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})" - \
      | tee ~/Pictures/Screenshots/"$(date +%F_%H-%M-%S)".png \
      | ${pkgs.wl-clipboard}/bin/wl-copy
  '';
in
{
  services.swaync = {
    enable = true;

    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      # A dropdown under the bar that fits its content, not a full-height sidebar
      fit-to-screen = false;
      control-center-height = -1;
      control-center-margin-top = 6;
      control-center-margin-bottom = 6;
      control-center-margin-right = 6;
      control-center-margin-left = 6;
      control-center-width = 400;
      notification-window-width = 400;
      transition-time = 200;
      hide-on-clear = false;
      hide-on-action = true;
      keyboard-shortcuts = true;

      widgets = [
        "menubar"
        "volume"
        "buttons-grid"
        "mpris"
        "title"
        "notifications"
      ];

      widget-config = {
        menubar = {
          "buttons#actions" = {
            position = "left";
            actions = [
              {
                label = "󰹑";
                command = closeAnd "screenshot" screenshot;
              }
              {
                label = "󰌾";
                command = closeAnd "lock" hyprlock;
              }
            ];
          };
          "menu#power" = {
            label = "󰐥";
            position = "right";
            actions = [
              {
                label = "󰤄   Suspend";
                command = closeAnd "suspend" "systemctl suspend";
              }
              {
                label = "󰜉   Restart";
                command = closeAnd "reboot" "systemctl reboot";
              }
              {
                label = "󰐥   Power Off";
                command = closeAnd "poweroff" "systemctl poweroff";
              }
              {
                label = "󰍃   Log Out";
                command = closeAnd "logout" "uwsm stop";
              }
            ];
          };
        };

        volume.label = "󰕾";

        buttons-grid = {
          buttons-per-row = 2;
          actions = [
            (toggle {
              label = "󰤨   Wi-Fi";
              on = "${nmcli} radio wifi on";
              off = "${nmcli} radio wifi off";
              state = "[ \"$(${nmcli} radio wifi)\" = enabled ]";
            })
            (toggle {
              label = "󰂯   Bluetooth";
              on = "${bluetoothctl} power on";
              off = "${bluetoothctl} power off";
              state = "${bluetoothctl} show | grep -q 'Powered: yes'";
            })
            (toggle {
              label = "󰂛   Do Not Disturb";
              on = "${swaync-client} -dn";
              off = "${swaync-client} -df";
              state = "[ \"$(${swaync-client} -D)\" = true ]";
            })
            {
              label = "󰛳   Network…";
              command = closeAnd "network" "${pkgs.networkmanagerapplet}/bin/nm-connection-editor";
            }
          ];
        };

        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear";
        };
      };
    };

    style = ''
      @define-color bg          ${theme.bg};
      @define-color surface     ${theme.surface};
      @define-color surface-alt ${theme.surfaceAlt};
      @define-color text        ${theme.text};
      @define-color subtext     ${theme.subtext};
      @define-color muted       ${theme.muted};
      @define-color accent      ${theme.accent};
      @define-color red         ${theme.red};

      * {
        border:        none;
        border-radius: 0;
        font-family:   "${theme.font}", monospace;
        font-size:     15px;
        min-height:    0;
      }

      .control-center {
        background-color: @bg;
        color:             @text;
        border-radius:     18px;
        padding:           10px;
      }

      /* top row: screenshot, lock … power menu */
      .widget-menubar {
        margin: 4px 3px 6px;
      }
      .widget-menubar .widget-menubar-container button {
        background-color: @surface-alt;
        border-radius:     99px;
        min-width:          38px;
        min-height:         38px;
        padding:           0;
        font-size:         17px;
      }
      .widget-menubar revealer button {
        background-color: @surface;
        border-radius:     12px;
        padding:           10px 14px;
      }
      .widget-menubar revealer button:hover {
        background-color: @surface-alt;
      }

      /* quick-settings tiles */
      .widget-buttons-grid {
        margin: 2px 0 6px;
      }
      .widget-buttons-grid flowboxchild > button {
        background-color: @surface-alt;
        border-radius:     99px;
        min-height:         44px;
        margin:            3px;
        padding:           0 16px;
      }
      .widget-buttons-grid flowboxchild > button:hover {
        background-color: @muted;
      }
      .widget-buttons-grid flowboxchild > button.toggle:checked {
        background-color: @accent;
        color:             @bg;
      }

      .control-center scrollbar slider {
        background-color: @muted;
        border-radius:     4px;
        min-width:          4px;
      }
      .control-center scrollbar slider:hover {
        background-color: @accent;
      }

      .widget-title,
      .widget-volume,
      .widget-mpris {
        background-color: @surface;
        border-radius:     12px;
        padding:           8px 10px;
        margin:            4px 3px 6px;
        color:             @text;
      }

      .widget-title label {
        font-weight: bold;
        color:       @text;
      }
      .widget-title button {
        background-color: @surface-alt;
        color:             @text;
        border-radius:     4px;
        padding:           4px 10px;
        font-size:         13px;
      }
      .widget-title button:hover {
        background-color: @muted;
      }

      .widget-volume label {
        color:        @accent;
        margin-right: 6px;
      }

      .widget-mpris-title {
        font-weight: bold;
        color:       @text;
      }
      .widget-mpris-subtitle {
        color: @subtext;
      }
      .widget-mpris-album-art {
        border-radius: 4px;
        min-width:      48px;
        min-height:     48px;
      }
      .widget-mpris-ctrl-btn {
        background:    transparent;
        color:         @text;
        border-radius: 4px;
        min-width:      28px;
        min-height:     28px;
      }
      .widget-mpris-ctrl-btn:hover {
        background-color: @surface-alt;
      }

      .notification-row {
        margin: 0 0 6px 0;
      }
      .notification {
        background-color: @surface;
        border-radius:     4px;
        padding:           10px 12px;
        transition:        150ms ease;
      }
      .notification:hover {
        background-color: @surface-alt;
      }
      .notification.critical {
        border-left: 3px solid @red;
      }

      .notification .image {
        border-radius: 4px;
      }
      .notification .close-button {
        background-color: @surface-alt;
        color:             @subtext;
        border-radius:     4px;
        min-width:          18px;
        min-height:         18px;
        font-size:         10px;
      }
      .notification .close-button:hover {
        background-color: @red;
        color:             @bg;
      }

      .summary {
        font-weight: bold;
        color:       @text;
        font-size:   14px;
      }
      .body {
        color:      @subtext;
        margin-top: 2px;
        font-size:  13px;
      }
      .time {
        color:     @muted;
        font-size: 11px;
      }

      .notification-action {
        background-color: @surface-alt;
        color:             @text;
        border-radius:     4px;
        margin-top:        6px;
        padding:           4px 8px;
        font-size:         13px;
      }
      .notification-action:hover {
        background-color: @accent;
        color:             @bg;
      }

      button {
        background-color: @surface-alt;
        color:             @text;
        border-radius:     4px;
        padding:           6px 12px;
      }
      button:hover {
        background-color: @muted;
      }
      button:active {
        background-color: @accent;
        color:             @bg;
      }

      scale trough {
        min-height:    4px;
        background-color: @surface-alt;
        border-radius:     4px;
      }
      scale highlight {
        background-color: @accent;
        border-radius:     4px;
      }
      scale slider {
        min-width:     12px;
        min-height:    12px;
        border-radius: 50%;
        background-color: @text;
      }
      scale slider:hover {
        background-color: @accent;
      }

      switch {
        background-color: @surface-alt;
        border-radius:     10px;
        min-width:          34px;
        min-height:         18px;
      }
      switch slider {
        background-color: @text;
        border-radius:     50%;
        min-width:          14px;
        min-height:         14px;
        margin:            2px;
      }
      switch:checked {
        background-color: @accent;
      }
      switch:checked slider {
        background-color: @bg;
      }
    '';
  };
}
