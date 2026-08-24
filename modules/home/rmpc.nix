{ theme, ... }:

{
  programs.rmpc = {
    enable = true;
    config = ''
      #![enable(implicit_some)]
      #![enable(unwrap_newtypes)]
      #![enable(unwrap_variant_newtypes)]
      (
        address: "127.0.0.1:6600",
        theme: "nix",
        volume_step: 5,
        album_art: (method: None),
      )
    '';
  };

  xdg.configFile."rmpc/themes/nix.ron".text = ''
    #![enable(implicit_some)]
    #![enable(unwrap_newtypes)]
    #![enable(unwrap_variant_newtypes)]
    (
      background_color: "${theme.bg}",
      text_color: "${theme.text}",
      borders_style: (fg: "${theme.muted}"),
      highlight_border_style: (fg: "${theme.accent}"),
      current_item_style: (fg: "${theme.bg}", bg: "${theme.accent}", modifiers: "Bold"),
      highlighted_item_style: (fg: "${theme.accent}", modifiers: "Bold"),
    )
  '';
}