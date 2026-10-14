{ lib, ... }:

{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true; # also sets nvidia-drm.modeset=1
    powerManagement.enable = true; # keep VRAM contents across suspend
    open = lib.mkDefault true;
  };
}
