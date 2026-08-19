{ pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.xkb = { layout = "us"; variant = ""; };
  services.displayManager.sddm.enable = true;

  security.rtkit.enable = true;
  security.pam.services.hyprlock = {};
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.xserver.excludePackages = [ pkgs.xterm ];

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland ];
  };
}