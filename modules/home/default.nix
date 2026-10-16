{ ... }:

{
  imports = [
    ./theme.nix
    ./cli.nix
    ./ssh.nix
    ./dev.nix
    ./packages.nix
    ./librewolf.nix
    ./tmux.nix
    ./obsidian.nix
    ./obsidian
  ];

  home.username = "ado";
  home.homeDirectory = "/home/ado";

  fonts.fontconfig.enable = true;
  programs.home-manager.enable = true;
}
