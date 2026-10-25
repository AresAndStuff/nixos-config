{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
    ./storage.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/server
    ../../modules/nixos/services/jellyfin.nix
    ../../modules/nixos/services/arr.nix
    ../../modules/nixos/services/torrent-vpn.nix
    ../../modules/nixos/services/monitoring.nix
    ../../modules/nixos/services/homepage.nix
    ../../modules/nixos/services/media-extras.nix
  ];

  networking.hostName = "nix-hs";
  networking.networkmanager.enable = true;

  console.keyMap = "sg";

  # No IPv6 privacy addresses on the server. Outgoing traffic has to use
  # the stable address, otherwise DynDNS publishes the wrong one.
  networking.tempAddresses = "disabled";

  system.stateVersion = "26.05";
}
