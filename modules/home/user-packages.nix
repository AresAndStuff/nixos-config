{ pkgs, ... }: {
  home.packages = with pkgs; [
    wl-clipboard
    vscodium
    librewolf
    fastfetch
    discord
  ];
}