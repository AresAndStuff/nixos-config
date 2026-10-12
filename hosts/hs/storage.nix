{ ... }:

{
  # Seagate Expansion 4 TB, USB 3.0 (uas), Serial NAC5ZN5Z
  # Uebergangsloesung bis zum Multi-Bay-Gehaeuse
  fileSystems."/srv/data" = {
    device = "/dev/disk/by-uuid/8019fc22-4839-4d34-a7c7-3031a836240c";
    fsType = "ext4";
    options = [
      "nofail"
      "noatime"
      "x-systemd.device-timeout=10s"
    ];
  };
  # Seagate-Bridge 0bc2:2037 reicht unter UAS kein SMART durch,
  # unter usb-storage schon. Bei einer HDD ohne messbaren Nachteil.
  boot.kernelParams = [ "usb-storage.quirks=0bc2:2037:u" ];
}
