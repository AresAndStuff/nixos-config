{ lan, mysecrets, ... }:
let
  keys = import "${mysecrets}/keys.nix";
in
{
  services.openssh = {
    enable = true;
    ports = [ lan.hs.sshPort ];
    openFirewall = false;

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

  users.users."nixhs".openssh.authorizedKeys.keys = [
    keys.ssh.desktop
    keys.ssh.laptop
  ];
}
