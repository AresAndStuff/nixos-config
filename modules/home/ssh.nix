{ lan, ... }:

let
  hs = {
    user = "nixhs";
    port = lan.hs.sshPort;
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
        hostname = lan.hs.vpnIp;
      };

      "hs" = hs // {
        hostname = lan.hs.ip;
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
