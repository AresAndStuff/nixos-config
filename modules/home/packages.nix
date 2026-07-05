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
}
