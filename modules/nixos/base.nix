{ lib, pkgs, ... }:

# Was jeder Host braucht — Desktop, Laptop und Server.
# Alles Grafische/Desktop-Spezifische steht in core.nix.
{
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
  # mkDefault: der Server überschreibt das (Chromebox-Firmware, siehe hosts/hs)
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Zurich";

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
  ];
}
