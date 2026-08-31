{ pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable = true;

    # GE-Proton, declaratively. Shows up in the game's compatibility dropdown.
    extraCompatPackages = with pkgs; [ proton-ge-bin ];

    # Steam Input on Wayland: translates X11 input events to uinput.
    # Only enable if you use a controller and it misbehaves.
    # extest.enable = true;
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.gamemode.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-qt   # optional, for pulling GE versions Nixpkgs hasn't updated to yet

    lutris
    wineWow64Packages.stable
    winetricks
    umu-launcher             # Lutris uses to run Proton
  ];
}