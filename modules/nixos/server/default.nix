{ ... }:

{
  imports = [
    ./ssh.nix
    ./users.nix
    ./firewall.nix
    ./fail2ban.nix
    ./time.nix
    ./logging.nix
    ./dyndns.nix
    ./wireguard.nix
  ];
}
