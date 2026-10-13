{ ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 2222 ];
    openFirewall = false;

    authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDKuvlEEzA/dWkaG9h2qydM/nSPV2Gm1Vs6LlqGbAxzT ado@nix-laptop"
    ];

    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      AuthenticationMethods = "publickey";
      AllowUsers = [ "nixhs" ];

      MaxAuthTries = 3;
      MaxSessions = 5;
      LoginGraceTime = 30;

      X11Forwarding = false;
      AllowAgentForwarding = false;
      AllowTcpForwarding = true;
      ClientAliveInterval = 300;
      ClientAliveCountMax = 2;
      LogLevel = "VERBOSE";
    };
  };
}
