{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
    ./storage.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/server
  ];

  networking.hostName = "nix-hs";
  networking.networkmanager.enable = true;

  console.keyMap = "sg";

  # No IPv6 privacy addresses on the server. Outgoing traffic has to use
  # the stable address, otherwise DynDNS publishes the wrong one.
  networking.tempAddresses = "disabled";

  system.stateVersion = "26.05";
}
