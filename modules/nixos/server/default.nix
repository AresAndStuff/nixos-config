{ ... }:

{
  imports = [
    ./ssh.nix
    ./firewall.nix
    ./fail2ban.nix
    ./time.nix
    ./logging.nix
    ./lan.nix
    ./dyndns.nix
    ./wireguard.nix
  ];
}
