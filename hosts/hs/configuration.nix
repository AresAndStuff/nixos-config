{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/server
    ../../modules/nixos/base.nix
    ./storage.nix
    ./secrets.nix
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

  # Server braucht keine IPv6-Privacy-Adressen. Ausgehend soll die
  # stabile Adresse benutzt werden, sonst traegt DynDNS die falsche ein.
  networking.tempAddresses = "disabled";

  system.stateVersion = "26.05";
}
