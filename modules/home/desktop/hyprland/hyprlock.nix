{ ... }:

{
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = false;
      };

      background = {
        monitor = "";
        path = "${../../../../assets/wallpaper.png}";
        blur_passes = 2;
        blur_size = 7;
        color = "rgba(17, 17, 17, 1.0)";
      };

      input-field = {
        monitor = "";
        size = "200, 50";
        outline_thickness = 3;
        dots_size = 0.33;
        dots_spacing = 0.15;
        fade_on_empty = false;
        rounding = 12;

        outer_color = "rgba(168, 153, 132, 0.8)";   # accent
        inner_color = "rgba(34, 34, 34, 0.9)";      # surface
        font_color = "rgba(221, 221, 221, 1.0)";    # text

        check_color = "rgba(137, 180, 130, 1.0)";   # green
        fail_color = "rgba(255, 85, 85, 1.0)";      # red

        font_family = "JetBrains Mono";
        placeholder_text = "Password...";
        position = "0, -20";
        halign = "center";
        valign = "center";
      };

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +\"%H:%M\")\"";
          color = "rgba(221, 221, 221, 1.0)";
          font_size = 90;
          font_family = "JetBrains Mono";
          position = "0, 160";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:60000] echo \"$(date +\"%A, %d %B\")\"";
          color = "rgba(153, 153, 153, 1.0)";   # muted
          font_size = 20;
          font_family = "JetBrains Mono";
          position = "0, 60";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "$USER";
          color = "rgba(168, 153, 132, 1.0)";   # accent
          font_size = 18;
          font_family = "JetBrains Mono";
          position = "0, -80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}