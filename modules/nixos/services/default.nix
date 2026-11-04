{ ... }:

# The home server's apps. Web UIs are opened to the LAN and VPN through
# homelab.lanTcpPorts, which comes from server/firewall.nix.
{
  imports = [
    ./jellyfin.nix
    ./arr.nix
    ./torrent-vpn.nix
    ./seerr.nix
    ./monitoring.nix
    ./homepage.nix
  ];
}
