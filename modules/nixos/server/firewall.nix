{ lib, lan, ... }:

{
  networking.nftables.enable = true;

  networking.firewall = {
    enable = true;
    # Modules open their own ports (e.g. wireguard.nix).

    allowPing = true;
    pingLimit = "5/second burst 10 packets";

    extraInputRules = lib.mkMerge [
      ''
        ip saddr ${lan.v4} tcp dport 2222 accept comment "SSH from LAN (v4)"
        ip6 saddr { ${lan.v6}, ${lan.linkLocal} } tcp dport 2222 accept comment "SSH from LAN (v6)"
        iifname "wg0" ip saddr ${lan.vpn} tcp dport 2222 accept comment "SSH from VPN"

        ip saddr ${lan.v4} meta l4proto igmp accept comment "IGMP from LAN"
      ''
      # mkAfter: stays the last rule, even if other modules add rules of their own
      (lib.mkAfter ''
        limit rate 3/minute burst 5 packets log prefix "fw-drop: " level warn
      '')
    ];
  };
}
