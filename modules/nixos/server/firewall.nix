{ lan, ... }:

{
  networking.nftables.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
    allowedUDPPorts = [ ];

    allowPing = true;
    pingLimit = "5/second burst 10 packets";

    extraInputRules = ''
      ip saddr ${lan.v4} tcp dport 2222 accept comment "SSH aus dem LAN (v4)"
      ip6 saddr { ${lan.v6}, ${lan.linkLocal} } tcp dport 2222 accept comment "SSH aus dem LAN (v6)"
      ip saddr ${lan.v4} meta l4proto igmp accept comment "IGMP aus dem LAN"

      # Muss die letzte Zeile bleiben: loggt, was nicht erlaubt wurde
      limit rate 3/minute burst 5 packets log prefix "fw-drop: " level warn
    '';
  };
}