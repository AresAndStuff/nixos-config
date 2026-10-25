{ lan, ... }:

# Seerr: request page (search a film/show, "request", it goes to Radarr/Sonarr).
#        Was Jellyseerr; in 26.05 the module is services.seerr.
let
  port = 5055;
in
{
  services.seerr = {
    enable = true;
    inherit port;
  };

  networking.firewall.extraInputRules = ''
    ip saddr ${lan.v4} tcp dport ${toString port} accept comment "Seerr from LAN (v4)"
    ip6 saddr ${lan.v6} tcp dport ${toString port} accept comment "Seerr from LAN (v6)"
    iifname "wg0" ip saddr ${lan.vpn} tcp dport ${toString port} accept comment "Seerr from VPN"
  '';
}
