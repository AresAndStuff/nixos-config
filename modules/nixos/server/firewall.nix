{
  config,
  lib,
  lan,
  ...
}:

let
  # Taken from ssh.nix, so moving sshd can't leave the rules on the old port (and lock SSH out).
  ssh = toString (lib.head config.services.openssh.ports);
in
{
  networking.nftables.enable = true;

  networking.firewall = {
    enable = true;
    # Modules open their own ports (e.g. wireguard.nix).

    allowPing = true;
    pingLimit = "5/second burst 10 packets";

    extraInputRules = lib.mkMerge [
      ''
        ip saddr ${lan.v4} tcp dport ${ssh} accept comment "SSH from LAN (v4)"
        ip6 saddr { ${lan.v6}, ${lan.linkLocal} } tcp dport ${ssh} accept comment "SSH from LAN (v6)"
        iifname "wg0" ip saddr ${lan.vpn} tcp dport ${ssh} accept comment "SSH from VPN"

        ip saddr ${lan.v4} meta l4proto igmp accept comment "IGMP from LAN"
      ''
      # mkAfter: stays the last rule, even if other modules add rules of their own
      (lib.mkAfter ''
        limit rate 3/minute burst 5 packets log prefix "fw-drop: " level warn
      '')
    ];
  };
}
