{
  lib,
  pkgs,
  agenix,
  ...
}:

# What every host needs: desktop, laptop and server.
# Graphical machines add workstation/, the server adds server/.
{
  imports = [ agenix.nixosModules.default ];

  # Every host decrypts with its own key. Which secrets it gets is
  # declared in hosts/<host>/secrets.nix.
  age.identityPaths = [ "/var/lib/agenix/key" ];

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
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Zurich";

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
  ];
}
