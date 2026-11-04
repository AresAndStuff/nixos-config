{ pkgs, ... }:

{
  services.jellyfin.enable = true;
  # Database, cache and metadata stay in /var/lib/jellyfin (SSD)

  # Without the USB disk Jellyfin would see an empty library and might
  # clean it out. Better not to start at all.
  systemd.services.jellyfin.unitConfig.RequiresMountsFor = "/srv/data";

  # Hardware transcoding on the UHD 620 (VAAPI)
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

  homelab.lanTcpPorts = [ 8096 ]; # web UI, the port isn't configurable here
}
