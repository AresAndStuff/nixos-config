{ pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ../../modules/nixos/server
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";
  services.xserver.xkb = { layout = "ch"; variant = ""; };
  console.keyMap = "sg";

  users.users."nixhs" = {
    isNormalUser = true;
    description = "nix-hs";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "nixhs" ];

  system.stateVersion = "26.05";
}