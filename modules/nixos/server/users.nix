{ ... }:

# The server's admin user. ssh.nix (AllowUsers, authorizedKeys) relies on this name.
{
  users.users.nixhs = {
    isNormalUser = true;
    description = "nix-hs";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Required for nixos-rebuild --target-host
  nix.settings.trusted-users = [ "nixhs" ];
}
