{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./secrets.nix
    ./wireguard.nix
    ../../modules/nixos/base.nix
    ../../modules/nixos/workstation
    ../../modules/nixos/hardware/nvidia.nix
    ../../modules/nixos/desktops/gnome.nix
  ];

  networking.hostName = "nix-laptop";

  boot.kernelParams = [ "acpi_backlight=native" ];
  hardware.nvidia.open = false;
  services.thermald.enable = true;

  system.stateVersion = "26.05";
}
