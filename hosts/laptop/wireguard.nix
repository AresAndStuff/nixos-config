{ ... }:

{
  networking.networkmanager.ensureProfiles = {
    # Enthält nur: WG_PRIVATE_KEY=<Inhalt von hs.key>
    environmentFiles = [ "/var/lib/wireguard/hs.env" ];

    profiles.hs-vpn = {
      connection = {
        id = "hs-vpn";
        type = "wireguard";
        interface-name = "hs";
        autoconnect = "false";
      };
      wireguard.private-key = "$WG_PRIVATE_KEY";
      "wireguard-peer.4MCQrlMLWs47XwEFZy0c3rkz+j53ksErUJC13BIVExc=" = {
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