{ ... }:

{
  programs.ssh = {
    enable = true;

    # Der implizite "Host *"-Block von Home Manager ist deprecated.
    # Seine Werte entsprachen ohnehin OpenSSHs eigenen Defaults, also
    # ersatzlos abschalten statt sie hier zu duplizieren.
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
