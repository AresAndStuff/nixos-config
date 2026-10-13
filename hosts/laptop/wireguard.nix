{ config, mysecrets, ... }:
let
  keys = import "${mysecrets}/keys.nix";
in
{
  networking.networkmanager.ensureProfiles = {
    # agenix: wg-laptop.env.age
    environmentFiles = [ config.age.secrets.wg-laptop-env.path ];

    profiles.hs-vpn = {
      connection = {
        id = "hs-vpn";
        type = "wireguard";
        interface-name = "hs";
        autoconnect = "false";
      };
      wireguard.private-key = "$WG_PRIVATE_KEY";
      "wireguard-peer.${keys.wg.hs}" = {
        endpoint = "vpn.nix4arn.lol:51820";
        allowed-ips = "10.77.0.1/32;";
      };
      ipv4 = {
        method = "manual";
        address1 = "10.77.0.3/32";
      };
      ipv6.method = "ignore";
    };
  };
}
