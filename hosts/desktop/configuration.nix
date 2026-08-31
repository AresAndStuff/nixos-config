{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    ../../secrets
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # Games / Steam library (ext4, same NVMe as root)
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/1804337c-9f08-4423-8a3b-be8fb63b2870";
    fsType = "ext4";
    options = [ "nofail" "noatime" ];
  };

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Zurich";

  # User account
  users.mutableUsers = false;
  users.users."ado" = {
    isNormalUser = true;
    description = "ado";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    hashedPasswordFile = config.age.secrets."passwort-ado".path;
  };

  system.stateVersion = "26.05";
}
