{ lan, ... }:

{
  services.fail2ban = {
    enable = true;

    maxretry = 3;
    bantime = "1h";

    # Never ban the LAN or VPN
    ignoreIP = [
      lan.v4
      lan.v6
      lan.linkLocal
      lan.vpn
    ];

    # The "sshd" jail picks up the port from services.openssh on its own
    jails.sshd.settings = {
      filter = "sshd[publickey=any]";
      findtime = "10m";
    };
  };
}
