{ pkgs, ... }: {
  home.packages = with pkgs; [
    wl-clipboard
    slurp
    grim
    vscodium
    fastfetch
    discord
    onlyoffice-desktopeditors
    anki
    hyprpaper
    libnotify
    sound-theme-freedesktop
    wlogout
    hyprlock
    swaynotificationcenter
  ];
}
