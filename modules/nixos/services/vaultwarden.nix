{
  config,
  lan,
  pkgs,
  ...
}:

# Vaultwarden: a Bitwarden-compatible password server. The official Bitwarden
# apps and browser extensions log in to it (choose "self-hosted" and enter
# https://vault.<domain>). Premium features (TOTP codes, attachments,
# emergency access, organisations) work without a subscription.
#
# LAN and VPN only, like everything else here. The name points at the
# server's LAN address (a DNS-only record in Cloudflare), and the certificate
# comes from Let's Encrypt through a Cloudflare DNS challenge, so nothing has
# to be reachable from the internet.
#
# First deploy: allowSignups = true, create your account, then set it to
# false and deploy again.
let
  allowSignups = false;
  domain = "vault.${lan.domain}";
  port = 8222;
  backupDir = "/srv/data/backup/vaultwarden";
in
{
  services.vaultwarden = {
    enable = true;
    inherit backupDir; # SQLite copy every night at 23:00
    config = {
      DOMAIN = "https://${domain}";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = port;
      SIGNUPS_ALLOWED = allowSignups;
      INVITATIONS_ALLOWED = false;
      SHOW_PASSWORD_HINT = false;
    };
  };

  # The backup goes to the USB disk; skip it rather than fill the SSD's
  # empty mount point when the disk is missing.
  systemd.services.backup-vaultwarden = {
    unitConfig.RequiresMountsFor = "/srv/data";
    serviceConfig.ExecStartPre = "+${pkgs.coreutils}/bin/install -d -m 700 -o vaultwarden -g vaultwarden ${backupDir}";
  };

  # Certificate via DNS-01, reusing the DynDNS token (needs Zone:Read and
  # DNS:Edit on the zone, which DynDNS needs as well).
  security.acme = {
    acceptTerms = true;
    certs.${domain} = {
      dnsProvider = "cloudflare";
      credentialFiles.CF_DNS_API_TOKEN_FILE = config.age.secrets.cloudflare-token.path;
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts.${domain} = {
      useACMEHost = domain;
      extraConfig = ''
        reverse_proxy 127.0.0.1:${toString port}
      '';
    };
  };

  homelab.lanTcpPorts = [ 443 ];
}
