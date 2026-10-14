{ pkgs, ... }:

{
  imports = [
    ../../modules/home
    ../../modules/home/desktops/gnome.nix
  ];

  home.packages = [ pkgs.vlc ];

  home.stateVersion = "26.05";
}
