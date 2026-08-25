{ theme, ... }:

{
  programs.wofi = {
    enable = true;

    settings = {
      # Window
      width = 550;
      height = 350;
      location = "center";
      layer = "overlay";
      term = "alacritty";

      show = "drun";
      prompt = "Search...";
      insensitive = true;
      matching = "contains";
      sort_order = "alphabetical";
      allow_images = true;
      image_size = 24;
      allow_markup = true;
      no_actions = true;
      hide_scroll = true;
      gtk_dark = true;
    };

    style = ''
      * {
        font-family: "${theme.font}", monospace;
        font-size: 13px;
      }

      window {
        margin: 0;
        padding: 10px;
        border: 1px solid alpha(${theme.accent}, 0.4);
        border-radius: 16px;
        background-color: alpha(${theme.bg}, 0.95);
      }

      #input {
        margin: 5px 5px 15px 5px;
        padding: 10px 14px;
        border: none;
        border-radius: 8px;
        color: ${theme.text};
        background-color: ${theme.surfaceAlt};
      }

      #inner-box, #outer-box {
        margin: 0;
        padding: 0;
        border: none;
        background-color: transparent;
      }

      #scroll {
        margin: 0;
        border: none;
      }

      #img {
        margin-right: 12px;
      }

      #text {
        margin: 4px 0;
        border: none;
        color: ${theme.accent};
      }

      #entry {
        padding: 8px 12px;
        border-radius: 8px;
        background-color: transparent;
      }

      #entry:selected {
        background-color: ${theme.accent};
        border-radius: 8px;
      }

      #entry:selected #text {
        color: ${theme.bg};
        font-weight: bold;
      }
    '';
  };
}
