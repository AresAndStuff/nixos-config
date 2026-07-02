{ pkgs, ... }: {
  home.packages = with pkgs; [
    wl-clipboard
    vscodium
    fastfetch
    discord
    onlyoffice-desktopeditors
    anki
    hyprpaper
  ];
  programs.librewolf = {
    enable = true;
    settings = {
      "widget.wayland.fractional-scale.enabled" = false;
    };
  };
}
