{ pkgs, ... }:

{
  # Nix / flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nixpkgs.config.allowUnfree = true;

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Fonts
  fonts.packages = with pkgs; [ nerd-fonts.hack ];
  fonts.fontconfig.defaultFonts.monospace = [ "Hack Nerd Font Mono" ];

  services.printing.enable = true;

  # System-side zsh (per-user config lives in home/cli.nix)
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    htop
    gnome-text-editor
  ];
}