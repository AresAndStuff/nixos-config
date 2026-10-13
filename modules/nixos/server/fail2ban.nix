{ lan, ... }:

{
  services.fail2ban = {
    enable = true;

    maxretry = 3;
    bantime = "1h";

    # Dein LAN wird nie gebannt
    ignoreIP = [
      lan.v4
      lan.v6
      lan.linkLocal
    ];

    # Der Jail "sshd" erkennt den SSH-Port 2222 selbst
    jails.sshd.settings = {
      filter = "sshd[publickey=any]";
      findtime = "10m";
    };
  };
}
