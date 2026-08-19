{ ... }:

{
  programs.wofi = {
    enable = true;

    settings = {
      # Window
      width = 600;
      height = 400;
      location = "center";
      layer = "overlay";
      term = "alacritty";

      # Behavior
      show = "drun";
      prompt = "Search...";
      insensitive = true;
      matching = "fuzzy";
      sort_order = "alphabetical";
      allow_images = true;
      image_size = 32;
      allow_markup = true;
      no_actions = true;   # hide the "run / run in terminal" context menu
      hide_scroll = true;
      gtk_dark = true;
    };

    style = ''
      * {
        font-family: "JetBrains Mono", monospace;
        font-size: 14px;
      }

      window {
        margin: 0;
        padding: 4px;
        border: 2px solid #a89984;
        border-radius: 12px;
        background-color: #1a1a1a;
      }

      #input {
        margin: 8px;
        padding: 8px 12px;
        border: none;
        border-radius: 6px;
        color: #dddddd;
        background-color: #222222;
      }

      #inner-box {
        margin: 0 8px 8px 8px;
        border: none;
        background-color: transparent;
      }

      #outer-box {
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
        margin-right: 10px;
      }

      #text {
        margin: 2px 0;
        border: none;
        color: #dddddd;
      }

      #entry {
        padding: 6px 8px;
        border-radius: 6px;
      }

      #entry:selected {
        background-color: #a89984;
      }

      #entry:selected #text {
        color: #1a1a1a;
        font-weight: bold;
      }
    '';
  };
}