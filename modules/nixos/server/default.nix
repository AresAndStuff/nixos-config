{ ... }:

{
  imports = [
    ./ssh.nix
    ./firewall.nix
    ./fail2ban.nix
    ./time.nix
    ./logging.nix
  ];
}
