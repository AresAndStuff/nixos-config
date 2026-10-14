{ ... }:

{
  # Seagate Expansion 4 TB, USB 3.0 (uas), Serial NAC5ZN5Z
  # Stopgap until the multi-bay enclosure arrives
  fileSystems."/srv/data" = {
    device = "/dev/disk/by-uuid/8019fc22-4839-4d34-a7c7-3031a836240c";
    fsType = "ext4";
    options = [
      "nofail"
      "noatime"
      "x-systemd.device-timeout=10s"
    ];
  };
  # The Seagate bridge 0bc2:2037 doesn't pass SMART through under UAS,
  # but does under usb-storage. No measurable downside for an HDD.
  boot.kernelParams = [ "usb-storage.quirks=0bc2:2037:u" ];
}
