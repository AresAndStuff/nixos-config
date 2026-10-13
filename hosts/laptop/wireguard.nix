{ ... }:

{
  networking.wg-quick.interfaces.hs = {
    address = [ "10.77.0.3/32" ];
    privateKeyFile = "/var/lib/wireguard/hs.key";

    # Zu Hause braucht der Laptop den Tunnel nicht (und der Router
    # leitet Verbindungen an die eigene oeffentliche IP vermutlich nicht
    # zurueck). Gestartet wird er von Hand, wenn man unterwegs ist.
    autostart = false;

    peers = [
      {
        publicKey = "4MCQrlMLWs47XwEFZy0c3rkz+j53ksErUJC13BIVExc=";
        endpoint = "vpn.nix4arn.lol:51820";
        allowedIPs = [ "10.77.0.1/32" ];
      }
    ];
  };
}
