{ ... }:

{
  programs.ssh = {
    enable = true;

    enableDefaultConfig = false;

    settings = {
      "hs" = {
        hostname = "192.168.1.195";
        user = "admin";
        port = 2222;
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
    };
  };
}
