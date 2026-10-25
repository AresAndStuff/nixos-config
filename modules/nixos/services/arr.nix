{ lib, lan, ... }:

let
  # Web UIs: LAN + VPN only, like Jellyfin
  ports = {
    qbittorrent = 8080;
    prowlarr = 9696;
    sonarr = 8989;
    radarr = 7878;
    lidarr = 8686;
  };
  writers = [
    "qbittorrent"
    "sonarr"
    "radarr"
    "lidarr"
  ];
in
{
  # One group for everything that touches /srv/data
  users.groups.media = { };
  users.users.jellyfin.extraGroups = [ "media" ];

  services.prowlarr.enable = true;
  services.sonarr = {
    enable = true;
    group = "media";
  };
  services.radarr = {
    enable = true;
    group = "media";
  };
  services.lidarr = {
    enable = true;
    group = "media";
  };
  services.qbittorrent = {
    enable = true;
    group = "media";
    webuiPort = ports.qbittorrent;
    # no serverConfig: it would make qBittorrent.conf read-only
  };
  services.flaresolverr.enable = true;

  systemd.services = lib.genAttrs writers (_: {
    unitConfig.RequiresMountsFor = "/srv/data";
    serviceConfig.UMask = lib.mkForce "0002"; # module default is 0022
  });

  networking.firewall.extraInputRules = lib.concatMapStrings (port: ''
    ip saddr ${lan.v4} tcp dport ${toString port} accept
    iifname "wg0" ip saddr ${lan.vpn} tcp dport ${toString port} accept
  '') (lib.attrValues ports);
}
