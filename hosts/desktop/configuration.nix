{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    ../../modules/nixos/nvidia.nix
    ../../modules/nixos/gaming.nix
    ../../modules/nixos/hyprland.nix
    ../../secrets
  ];

  networking.hostName = "nix-desktop";

  # Games / Steam library (ext4, same NVMe as root)
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/1804337c-9f08-4423-8a3b-be8fb63b2870";
    fsType = "ext4";
    options = [ "nofail" "noatime" "x-gvfs-show" ];
  };

  users.mutableUsers = false;
  users.users.ado.hashedPasswordFile = config.age.secrets."passwort-ado".path;

  system.stateVersion = "26.05";
}
