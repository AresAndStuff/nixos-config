{ nix-flatpak, ... }:

# System-wide Flatpaks, declared with nix-flatpak. Apps are installed by a
# systemd service on activation, so the first rebuild needs network access.
{
  imports = [ nix-flatpak.nixosModules.nix-flatpak ];

  services.flatpak = {
    enable = true; # adds the flathub remote by default

    # Weekly background updates. Flatpaks are not pinned by flake.lock.
    update.auto = {
      enable = true;
      onCalendar = "weekly";
    };

    # Uncomment to remove every Flatpak (and remote) that isn't listed here.
    # uninstallUnmanaged = true;

    # App IDs from flathub.org, e.g. "com.obsproject.Studio".
    # Per-host extras can be added in hosts/<host>/configuration.nix; lists merge.
    packages = [ ];
  };
}
