{ pkgs, ... }:

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

      exec-once = [ "waybar" "swaync" "hyprpaper" ];

      general = {
        gaps_in = 3;
        gaps_out = 5;
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
        "SUPER, Space, exec, pkill wofi || wofi --show drun"
        "SUPER, Q, killactive,"
        "SUPER, F, togglefloating,"
        "SUPER, M, exit,"
        "SUPER, V, layoutmsg, togglesplit" 

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
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };
  };
}