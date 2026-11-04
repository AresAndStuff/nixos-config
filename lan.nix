# Home network addresses, passed to every NixOS and Home Manager module as
# `lan` (see flake.nix). The only place for them: change them here.
let
  domain = "nix4arn.lol"; # DNS at Cloudflare
in
{
  inherit domain;

  # Subnets, for firewall rules and fail2ban.
  # Sunrise assigns the v6 prefix dynamically. If it changes, update it
  # here only. Current prefix (on the server): ip -6 addr show scope global
  v4 = "192.168.1.0/24";
  v6 = "2001:1708:2498:500::/64";
  linkLocal = "fe80::/10";
  vpn = "10.77.0.0/24";

  router = "192.168.1.1";

  # The home server
  hs = {
    ip = "192.168.1.195";
    vpnIp = "10.77.0.1";
    sshPort = 2222;
  };

  # WireGuard: wg0 on the server, the laptop's NetworkManager profile
  wg = {
    endpoint = "vpn.${domain}"; # kept pointed at home by DynDNS
    port = 51820;
    peers = {
      phone = "10.77.0.2";
      laptop = "10.77.0.3";
    };
  };
}
