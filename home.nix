{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should manage.
  home.username = "ado";
  home.homeDirectory = "/home/ado";

  # Packages that should be installed for your user.
  home.packages = with pkgs; [
    vscodium
    librewolf
    fastfetch
    discord
  ];

  # Basic configuration for your shell
  programs.bash.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with.
  home.stateVersion = "26.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
