{ pkgs, ... }:

{
  imports = [
    ./base.nix
    ./bluetooth.nix
  ];

  networking.networkmanager.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    corefonts
    vista-fonts
    liberation_ttf
    dejavu_fonts
  ];
  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = [ "Hack Nerd Font Mono" ];
  };

  services.printing.enable = true;
  programs.zsh.enable = true;
  programs.nix-ld.enable = true;

  # Passwort kommt pro Host dazu: Desktop aus agenix, Laptop von Hand.
  users.users.ado = {
    isNormalUser = true;
    description = "ado";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };
}
