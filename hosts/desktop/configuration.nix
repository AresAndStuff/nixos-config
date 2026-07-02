{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    ../../secrets
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 4;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # Extra NTFS data drive
  fileSystems."/run/media/ado/BCEA64D5EA648E08" = {
    device = "/dev/disk/by-uuid/BCEA64D5EA648E08";
    fsType = "ntfs-3g";
    options = [ "nofail" "uid=1000" "gid=100" "umask=000" "exec" "user" "rw" ];
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