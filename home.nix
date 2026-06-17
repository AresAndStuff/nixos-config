{ config, pkgs, ... }:

{
  imports = [ ./modules/user-packages.nix ];

  home.username = "ado";
  home.homeDirectory = "/home/ado";

  programs.bash.enable = true;
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}