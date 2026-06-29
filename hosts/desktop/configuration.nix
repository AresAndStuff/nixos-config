{ config, pkgs, self, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      "${self}/modules/nixos/nvidia.nix"
      "${self}/modules/nixos/desktop.nix"
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  fileSystems."/run/media/ado/BCEA64D5EA648E08" = {
    device = "/dev/disk/by-uuid/BCEA64D5EA648E08";
    fsType = "ntfs-3g";
    options = [ "nofail" "uid=1000" "gid=100" "umask=000" "exec" "user" "rw" ];
  };

  boot.loader.systemd-boot.configurationLimit = 4;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  fonts.fontconfig = {
    defaultFonts = {
      monospace = [ "Hack Nerd Font Mono" ];
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Zurich";

  i18n.defaultLocale = "en_US.UTF-8";

  services.printing.enable = true;

  programs.zsh.enable = true;

  users.mutableUsers = false;
  users.users."ado" = {
    isNormalUser = true;
    description = "ado";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    hashedPasswordFile = config.age.secrets."passwort-ado".path;
  };

  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    htop
    gnome-text-editor
  ];

  system.stateVersion = "26.05";

}
