{ ... }:

{
  # The only place for home network addresses.
  # Sunrise assigns the v6 prefix dynamically. If it changes, update it
  # here only. Current prefix: ip -6 addr show scope global
  _module.args.lan = {
    v4 = "192.168.1.0/24";
    v6 = "2001:1708:2498:500::/64";
    linkLocal = "fe80::/10";
    vpn = "10.77.0.0/24";
  };
}
