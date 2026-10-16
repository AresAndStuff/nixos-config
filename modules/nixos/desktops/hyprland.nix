{ assets, pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # Run Electron/Chromium apps natively on Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  services.xserver.enable = true;
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.udisks2.enable = true;
  services.blueman.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "catppuccin-mocha-rosewater";
  };

  security.pam.services.hyprlock = { };
  security.pam.services.sddm.kwallet = {
    enable = true;
    package = pkgs.kdePackages.kwallet-pam;
  };

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  programs.dconf.enable = true;
  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [
        "hyprland"
        "gtk"
      ];
    };
  };

  environment.systemPackages = with pkgs.kdePackages; [
    qtsvg
    kwallet
    kwallet-pam
    kwalletmanager
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      accent = "rosewater";
      background = "${assets}/wallpaper.png";
      font = "JetBrainsMono Nerd Font";
      fontSize = "20";
    })
  ];
}
