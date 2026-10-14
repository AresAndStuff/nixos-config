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

    # The "sshd" jail picks up SSH port 2222 on its own
    jails.sshd.settings = {
      filter = "sshd[publickey=any]";
      findtime = "10m";
    };
  };
}
