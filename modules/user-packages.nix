{ pkgs, ... }: {
  home.packages = with pkgs; [
    vscodium
    librewolf
    fastfetch
    discord
  ];
}