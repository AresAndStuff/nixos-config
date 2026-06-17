{ config, pkgs, ... }: {
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    forceFullCompositionPipeline = false;
  };
  boot.kernelParams = [ "nvidia-drm.modeset=1" "nvidia.NV_alloc_callback_space=1" ];
}