{ config, pkgs, plasma-manager, ... }:

{
  imports = [
    ./modules/home/user-packages.nix
    ./modules/home/cli.nix
    ./modules/home/plasma.nix
    plasma-manager.homeModules.plasma-manager
    ];

  home.username = "ado";
  home.homeDirectory = "/home/ado";

  fonts.fontconfig.enable = true;

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}