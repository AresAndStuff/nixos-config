{ config, mysecrets, ... }:
let
  keys = import "${mysecrets}/keys.nix";
in
{
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.77.0.1/24" ];
    listenPort = 51820;

    # Bei Neuinstallation: neuen Host-Key in keys.nix eintragen, agenix -r, deployen.
    privateKeyFile = config.age.secrets.wg-hs.path;

    peers = [
      {
        # Handy
        publicKey = keys.wg.phone;
        allowedIPs = [ "10.77.0.2/32" ];
      }
      {
        # Laptop
        publicKey = keys.wg.laptop;
        allowedIPs = [ "10.77.0.3/32" ];
      }
    ];
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];

  # NetworkManager soll das Interface nicht anfassen
  networking.networkmanager.unmanaged = [ "wg0" ];
}
