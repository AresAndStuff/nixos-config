{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    ../../modules/nixos/gnome.nix
    ./wireguard.nix
  ];

  networking.hostName = "nix-laptop";

  boot.kernelParams = [ "acpi_backlight=native" ];
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    # If you use the open-source kernel modules (recommended for modern cards on newer kernels):
    open = false; 
  };

  # Kein agenix auf dem Laptop. Nach dem ersten Boot: passwd ado
  users.mutableUsers = true;

  system.stateVersion = "26.05";
}
