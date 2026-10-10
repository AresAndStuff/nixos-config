{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    ../../modules/nixos/gnome.nix
  ];

  networking.hostName = "nix-laptop";

  # Kein agenix auf dem Laptop. Nach dem ersten Boot: passwd ado
  users.mutableUsers = true;

  system.stateVersion = "26.05";
}