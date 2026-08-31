{ pkgs, ... }:

let
  playpause = pkgs.writeShellApplication {
    name = "playpause";
    runtimeInputs = with pkgs; [ coreutils playerctl util-linux ];
    text = builtins.readFile ./scripts/playpause.sh;
  };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false;
    configType = "hyprlang";

    settings = {
      xwayland = {
        force_zero_scaling = true;
      };

      general = {
        gaps_in = 3;
        gaps_out = 5;
        allow_tearing = true;
      };

      dwindle = {
        preserve_split = true;
      };

      decoration = {
        active_opacity = 1.0;
        inactive_opacity = 0.8; # Werte zwischen 0.0 und 1.0
      };

      input = {
        kb_layout = "us";
        follow_mouse = 1;
      };

      bind = [
        "SUPER, T, exec, alacritty"
        "SUPER, Space, exec, pkill wofi || wofi"
        "SUPER, Q, killactive,"
        "SUPER, F, togglefloating,"
        "SUPER, M, exit,"
        "SUPER, V, layoutmsg, togglesplit"
        "SUPER, L, exec, pkill wlogout || wlogout-menu"

        "SUPER, left, movefocus, l"
        "SUPER, right, movefocus, r"
        "SUPER, up, movefocus, u"
        "SUPER, down, movefocus, d"

        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"

        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"

        "SUPER, Tab, cyclenext,"
        "SUPER, Tab, bringactivetotop,"

        "SUPER, S, exec, grim -g \"$(slurp)\" - | tee ~/Pictures/Screenshots/$(date +%F_%H-%M-%S).png | wl-copy && notify-send 'Region captured' -t 1000"
        "SUPER SHIFT, S, exec, grim - | tee ~/Pictures/Screenshots/$(date +%F_%H-%M-%S).png | wl-copy && notify-send 'Screen captured' -t 1000"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
      
      bindel = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ];

      bindl = [
        ", XF86AudioMute, exec, ${playpause}/bin/playpause"
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl -p mpd play-pause"
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl -p mpd next"
        ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl -p mpd previous"
      ];
    };

    extraConfig = ''
      windowrule = match:class ^(steam)$, match:title ^$, stay_focused on
      windowrule = match:class ^(steam_app_\d+)$, no_blur on
    '';
  };
}