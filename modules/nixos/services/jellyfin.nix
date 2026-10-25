{ pkgs, lan, ... }:

{
  services.jellyfin.enable = true;
  # Datenbank, Cache und Metadaten bleiben unter /var/lib/jellyfin (SSD)

  # Fehlt die USB-Platte, sähe Jellyfin eine leere Mediathek und räumt
  # womöglich die Bibliothek ab. Dann lieber gar nicht starten.
  systemd.services.jellyfin.unitConfig.RequiresMountsFor = "/srv/data";

  # Hardware-Transcoding über die UHD 620 (VAAPI)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime-legacy1 # OpenCL for Gen8–11 (Kaby Lake) – Jellyfin tone mapping
    ];
  };
  users.users.jellyfin.extraGroups = [
    "render"
    "video"
  ];

  # Nur LAN und VPN, nichts öffentlich. Die Log-Regel bleibt dank mkAfter die letzte.
  networking.firewall.extraInputRules = ''
    ip saddr ${lan.v4} tcp dport 8096 accept comment "Jellyfin aus dem LAN (v4)"
    ip6 saddr ${lan.v6} tcp dport 8096 accept comment "Jellyfin aus dem LAN (v6)"
    iifname "wg0" ip saddr ${lan.vpn} tcp dport 8096 accept comment "Jellyfin aus dem VPN"
  '';
}
