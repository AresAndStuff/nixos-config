{ ... }:

let
  hs = {
    user = "nixhs";
    port = 2222;
    identityFile = "~/.ssh/id_ed25519_hs";
    identitiesOnly = true;
  };
in
{
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;

    settings = {
      "hs-vpn" = hs // {
        hostname = "10.77.0.1";
      };

      "hs" = hs // {
        hostname = "192.168.1.195";
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
