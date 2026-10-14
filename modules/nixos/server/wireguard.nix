{ config, mysecrets, ... }:
let
  keys = import "${mysecrets}/keys.nix";
in
{
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.77.0.1/24" ];
    listenPort = 51820;

    # After a reinstall: add the new host key to keys.nix, run agenix -r, deploy.
    privateKeyFile = config.age.secrets.wg-hs.path;

    peers = [
      {
        # Phone
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

  # Keep NetworkManager away from this interface
  networking.networkmanager.unmanaged = [ "wg0" ];
}
