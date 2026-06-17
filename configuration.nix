{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/nvidia.nix
      ./modules/desktop.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.systemd-boot.configurationLimit = 4;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

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

  programs.bash = {
  enable = true;
  shellAliases = {
    vage = "sudo EDITOR=nano nix run github:ryantm/agenix -- -i /etc/ssh/ssh_host_agenix_key -e";
  };
};

  users.mutableUsers = false;
  users.users."ado" = {
    isNormalUser = true;
    description = "ado";
    extraGroups = [ "networkmanager" "wheel" ];
    hashedPasswordFile = config.age.secrets."passwort-ado".path;
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    htop
  ];

  system.stateVersion = "26.05";

}
