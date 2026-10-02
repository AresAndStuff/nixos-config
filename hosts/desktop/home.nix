{ ... }:

{
  imports = [
    ../../modules/home
    ../../modules/home/mpd.nix
    ../../modules/home/rmpc.nix
    ../../modules/home/desktop
  ];

  home.username = "ado";
  home.homeDirectory = "/home/ado";
  home.stateVersion = "26.05";

  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;
}