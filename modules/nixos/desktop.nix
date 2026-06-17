{ config, pkgs, ... }: {
  services.xserver.enable = true;
  services.xserver.xkb = { layout = "us"; variant = ""; };
  
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.xserver.excludePackages = [ pkgs.xterm ];
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    discover
    elisa
    kate
    konsole
    qrca
  ];
}