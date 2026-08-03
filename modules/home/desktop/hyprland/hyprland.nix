{ ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    systemd.enable = false;
    configType = "hyprlang";

    settings = {
      exec-once = [ "waybar" "mako" "hyprpaper" ];

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
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };
  };
}