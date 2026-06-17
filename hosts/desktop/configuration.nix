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

  boot.loader.systemd-boot.configurationLimit = 4;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  fonts.fontconfig = {
    defaultFonts = {
      monospace = [ "monospace" ];
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
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  nixpkgs.config.allowUnfree = true;

  fonts.packages = with pkgs; [
    nerd-fonts.hack
  ];

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    htop
  ];

  system.stateVersion = "26.05";

}
