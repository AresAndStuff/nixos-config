{ ... }:

{
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.77.0.1/24" ];
    listenPort = 51820;

    # Wird beim ersten Start auf dem Server erzeugt und verlaesst ihn nie.
    # Bei Neuinstallation: neuer Schluessel, Clients muessen nachgezogen werden.
    privateKeyFile = "/var/lib/wireguard/wg0.key";
    generatePrivateKeyFile = true;

    peers = [
      {
        # Handy
        publicKey = "PDiyxLKOT/X/D4Vc8z9ZmHVMDVg7DWe4xgSgCmkgTx4=";
        allowedIPs = [ "10.77.0.2/32" ];
      }
      {
        # Laptop
        publicKey = "yIr+Dum1HLCwFajJYPDWP5Of8LY+Rze81irpUODSh0E=";
        allowedIPs = [ "10.77.0.3/32" ];
      }
    ];
  };

  networking.firewall.allowedUDPPorts = [ 51820 ];

  # NetworkManager soll das Interface nicht anfassen
  networking.networkmanager.unmanaged = [ "wg0" ];
}
