{ config, pkgs, plasma-manager, ... }:

{
  imports = [
    ./modules/home/user-packages.nix
    ./modules/home/cli.nix
    plasma-manager.homeManagerModules.plasma-manager
    ];

  home.username = "ado";
  home.homeDirectory = "/home/ado";

  fonts.fontconfig.enable = true;

  programs.plasma = {
    enable = true;
    workspace.lookAndFeel = "org.kde.breezedark.desktop";
    hotkeys.commands."run-alacritty" = {
      name = "Launch Alacritty";
      key = "Ctrl+Alt+T";
      command = "alacritty";
    };
  };

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
}