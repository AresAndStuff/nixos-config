{ pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Laptop-Kram
  services.thermald.enable = true;

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    epiphany
    geary
    totem
    gnome-music
  ];
}
