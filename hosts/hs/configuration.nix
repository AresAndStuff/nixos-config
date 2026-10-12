{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/server
    ../../modules/nixos/base.nix
    ./storage.nix
  ];

  networking.hostName = "nix-hs";
  networking.networkmanager.enable = true;

  services.xserver.xkb = {
    layout = "ch";
    variant = "";
  };
  console.keyMap = "sg";

  users.users."nixhs" = {
    isNormalUser = true;
    description = "nix-hs";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  nix.settings.trusted-users = [ "nixhs" ];

  system.stateVersion = "26.05";
}
