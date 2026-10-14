{ theme, assets, ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = false;
      };

      background = {
        monitor = "";
        path = "${assets}/wallpaper.png";
        blur_passes = 2;
        blur_size = 7;
        color = theme.withAlpha theme.bg "ff";
      };

      input-field = {
        monitor = "";
        size = "200, 50";
        outline_thickness = 3;
        dots_size = 0.33;
        dots_spacing = 0.15;
        fade_on_empty = false;
        rounding = 12;

        outer_color = theme.withAlpha theme.accent "cc";
        inner_color = theme.withAlpha theme.surface "e6";
        font_color = theme.withAlpha theme.text "ff";
        check_color = theme.withAlpha theme.green "ff";
        fail_color = theme.withAlpha theme.red "ff";

        font_family = theme.font;
        placeholder_text = "Password...";
        position = "0, -20";
        halign = "center";
        valign = "center";
      };

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%H:%M\")\"";
          color = theme.withAlpha theme.text "ff";
          font_size = 90;
          font_family = theme.font;
          position = "0, 160";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:60000] echo \"$(date +\"%A, %d %B\")\"";
          color = theme.withAlpha theme.subtext "ff";
          font_size = 20;
          font_family = theme.font;
          position = "0, 60";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "$USER";
          color = theme.withAlpha theme.accent "ff";
          font_size = 18;
          font_family = theme.font;
          position = "0, -80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
