{ ... }:

{
  imports = [
    ../../modules/home
    ../../modules/home/gnome.nix
  ];

  home.username = "ado";
  home.homeDirectory = "/home/ado";
  home.stateVersion = "26.05";

  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;
}