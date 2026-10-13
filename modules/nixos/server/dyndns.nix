{ config, ... }:

{
  services.cloudflare-dyndns = {
    enable = true;
    apiTokenFile = config.age.secrets.cloudflare-token.path;
    domains = [ "vpn.nix4arn.lol" ];
    ipv4 = true;
    ipv6 = true;    # Standard ist false
    # proxied = false ist Standard und muss so bleiben: WireGuard geht nicht durch den Proxy
  };
}