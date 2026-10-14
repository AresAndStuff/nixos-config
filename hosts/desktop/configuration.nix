{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/workstation
    ../../modules/nixos/hardware/nvidia.nix
    ../../modules/nixos/desktops/hyprland.nix
    ../../modules/nixos/gaming.nix
  ];

  networking.hostName = "nix-desktop";

  # TODO: The NVIDIA driver probably doesn't know this parameter.
  # Find out where it came from; if nothing changes without it, delete it.
  boot.kernelParams = [ "nvidia.NV_alloc_callback_space=1" ];

  # Games / Steam library (ext4, same NVMe as root)
  fileSystems."/mnt/games" = {
    device = "/dev/disk/by-uuid/1804337c-9f08-4423-8a3b-be8fb63b2870";
    fsType = "ext4";
    options = [
      "nofail"
      "noatime"
      "x-gvfs-show"
    ];
  };

  system.stateVersion = "26.05";
}
