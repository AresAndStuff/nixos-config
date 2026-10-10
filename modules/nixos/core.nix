{ pkgs, ... }:

{
  imports = [ ./bluetooth.nix ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Zurich";
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

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    btop
  ];
}
