{ config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    ../../modules/nixos/gnome.nix
    ./wireguard.nix
    ./secrets.nix
  ];

  networking.hostName = "nix-laptop";

  boot.kernelParams = [ "acpi_backlight=native" ];
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true; # saves VRAM on suspend, enables nvidia-suspend/resume services
    open = false;
  };

  users.mutableUsers = false;
  users.users.ado.hashedPasswordFile = config.age.secrets."passwort-ado".path;

  system.stateVersion = "26.05";
}
