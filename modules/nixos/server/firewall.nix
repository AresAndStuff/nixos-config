{
  config,
  lib,
  lan,
  ...
}:

let
  # Taken from ssh.nix, so moving sshd can't leave the rules on the old port (and lock SSH out).
  ssh = toString (lib.head config.services.openssh.ports);

  lanPorts = lib.concatMapStringsSep ", " toString (
    lib.sort lib.lessThan (lib.unique config.homelab.lanTcpPorts)
  );
in
{
  options.homelab.lanTcpPorts = lib.mkOption {
    type = lib.types.listOf lib.types.port;
    default = [ ];
    example = [ 8096 ];
    description = "TCP ports open to the LAN and the VPN, never to the internet. For web UIs.";
  };

  config = {
    networking.nftables.enable = true;

    networking.firewall = {
      enable = true;
      # Web UIs add their port to homelab.lanTcpPorts; anything else opens
      # its own (e.g. wireguard.nix).

      allowPing = true;
      pingLimit = "5/second burst 10 packets";

      extraInputRules = lib.mkMerge [
        ''
          ip saddr ${lan.v4} tcp dport ${ssh} accept comment "SSH from LAN (v4)"
          ip6 saddr { ${lan.v6}, ${lan.linkLocal} } tcp dport ${ssh} accept comment "SSH from LAN (v6)"
          iifname "wg0" ip saddr ${lan.vpn} tcp dport ${ssh} accept comment "SSH from VPN"

          ip saddr ${lan.v4} meta l4proto igmp accept comment "IGMP from LAN"
        ''
        (lib.mkIf (config.homelab.lanTcpPorts != [ ]) ''
          ip saddr ${lan.v4} tcp dport { ${lanPorts} } accept comment "Web UIs from LAN (v4)"
          ip6 saddr ${lan.v6} tcp dport { ${lanPorts} } accept comment "Web UIs from LAN (v6)"
          iifname "wg0" ip saddr ${lan.vpn} tcp dport { ${lanPorts} } accept comment "Web UIs from VPN"
        '')
        # mkAfter: stays the last rule, even if other modules add rules of their own
        (lib.mkAfter ''
          limit rate 3/minute burst 5 packets log prefix "fw-drop: " level warn
        '')
      ];
    };
  };
}
