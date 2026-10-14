{ pkgs, ... }:

# VLC is added per host (scaled on the desktop, plain on the laptop).
{
  home.packages = with pkgs; [
    vscodium
    fastfetch
    discord
    libreoffice
    anki
    ungoogled-chromium
    pdfarranger
    scrcpy
    android-tools
    nixfmt
    nixfmt-tree
  ];
}
