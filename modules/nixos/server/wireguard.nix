{
  config,
  lan,
  mysecrets,
  ...
}:

let
  keys = import "${mysecrets}/keys.nix";
in
{
  networking.wireguard.interfaces.wg0 = {
    ips = [ "${lan.hs.vpnIp}/24" ];
    listenPort = lan.wg.port;

    # After a reinstall: add the new host key to keys.nix, run agenix -r, deploy.
    privateKeyFile = config.age.secrets.wg-hs.path;

    peers = [
      {
        # Phone
        publicKey = keys.wg.phone;
        allowedIPs = [ "${lan.wg.peers.phone}/32" ];
      }
      {
        # Laptop
        publicKey = keys.wg.laptop;
        allowedIPs = [ "${lan.wg.peers.laptop}/32" ];
      }
    ];
  };

  networking.firewall.allowedUDPPorts = [ lan.wg.port ];

  # Keep NetworkManager away from this interface
  networking.networkmanager.unmanaged = [ "wg0" ];
}
