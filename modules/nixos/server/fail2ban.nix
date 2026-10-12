{ ... }:

{
  services.fail2ban = {
    enable = true;

    maxretry = 3;
    bantime = "1h";

    # Dein LAN wird nie gebannt
    ignoreIP = [
      "192.168.1.0/24"
      "2001:1708:2483:8800::/64"
      "fe80::/10"
    ];

    # Der Jail "sshd" erkennt den SSH-Port 2222 selbst
    jails.sshd.settings = {
      filter = "sshd[publickey=any]";
      findtime = "10m";
    };
  };
}
