{ config, lan, ... }:

{
  services.cloudflare-dyndns = {
    enable = true;
    apiTokenFile = config.age.secrets.cloudflare-token.path;
    domains = [ lan.wg.endpoint ];
    ipv4 = true;
    ipv6 = true; # default is false
    # proxied = false is the default and must stay that way: WireGuard can't go through the proxy
  };
}
