{ ... }:

{
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;

    settings = {
      "hs-vpn" = {
        hostname = "10.77.0.1";
        user = "nixhs";
        port = 2222;
        identityFile = "~/.ssh/id_ed25519_hs";
        identitiesOnly = true;
      };

      "hs" = {
        hostname = "192.168.1.195";
        user = "nixhs";
        port = 2222;
        identityFile = "~/.ssh/id_ed25519_hs";
        identitiesOnly = true;
      };

      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_github";
        identitiesOnly = true;
      };
    };
  };
}
