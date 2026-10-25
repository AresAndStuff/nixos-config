{
  config,
  lib,
  lan,
  ...
}:

# Start page with links to every service. Each tile has a status dot and a
# widget with live numbers; both are fetched server-side over localhost.
# API keys and logins come from agenix as HOMEPAGE_VAR_* (homepage.env.age).
let
  port = 8082;

  # Address the browser uses for the links. Over the VPN the server is
  # 10.77.0.1, so these links only work in the LAN until Caddy gives the
  # services proper names.
  host = "192.168.1.195";
  link = p: "http://${host}:${toString p}";
  local = p: "http://127.0.0.1:${toString p}";

  tile =
    {
      name,
      p,
      description,
      icon,
      widget ? null,
    }:
    {
      ${name} = {
        href = link p;
        siteMonitor = local p;
        inherit description icon;
      }
      // lib.optionalAttrs (widget != null) {
        widget = widget // {
          url = local p;
        };
      };
    };

  arr = name: p: description: {
    inherit name p description;
    icon = "${lib.toLower name}.svg";
    widget = {
      type = lib.toLower name;
      key = "{{HOMEPAGE_VAR_${lib.toUpper name}_KEY}}";
    };
  };
in
{
  services.homepage-dashboard = {
    enable = true;
    listenPort = port;
    # Homepage refuses requests whose Host header isn't listed here
    allowedHosts = "${host}:${toString port},10.77.0.1:${toString port}";
    environmentFiles = [ config.age.secrets.homepage-env.path ];

    settings = {
      title = "nix-hs";
      theme = "light";
      color = "neutral";
      headerStyle = "clean";
      statusStyle = "dot";
      hideVersion = true;
      layout = {
        Medien = {
          style = "row";
          columns = 2;
        };
        Downloads = {
          style = "row";
          columns = 3;
        };
        System = {
          style = "row";
          columns = 2;
        };
      };
    };

    widgets = [
      {
        resources = {
          cpu = true;
          memory = true;
          cputemp = true;
          uptime = true;
          units = "metric";
        };
      }
      {
        resources = {
          label = "SSD";
          disk = "/";
        };
      }
      {
        resources = {
          label = "Daten";
          disk = "/srv/data";
        };
      }
      {
        datetime = {
          text_size = "md";
          locale = "de-CH";
          format = {
            dateStyle = "long";
            timeStyle = "short";
            hour12 = false;
          };
        };
      }
    ];

    services = [
      {
        Medien = [
          (tile {
            name = "Jellyfin";
            p = 8096;
            description = "Filme, Serien, Musik";
            icon = "jellyfin.svg";
            widget = {
              type = "jellyfin";
              key = "{{HOMEPAGE_VAR_JELLYFIN_KEY}}";
              enableBlocks = true;
              enableNowPlaying = true;
            };
          })
          (tile {
            name = "Seerr";
            p = 5055;
            description = "Wünsche";
            icon = "jellyseerr.svg";
            widget = {
              type = "jellyseerr"; # same API as Seerr
              key = "{{HOMEPAGE_VAR_SEERR_KEY}}";
            };
          })
        ];
      }
      {
        Downloads = [
          (tile {
            name = "qBittorrent";
            p = 8080;
            description = "über Proton VPN";
            icon = "qbittorrent.svg";
            widget = {
              type = "qbittorrent";
              username = "{{HOMEPAGE_VAR_QBIT_USER}}";
              password = "{{HOMEPAGE_VAR_QBIT_PASS}}";
            };
          })
          (tile (arr "Prowlarr" 9696 "Indexer"))
          (tile (arr "Sonarr" 8989 "Serien"))
          (tile (arr "Radarr" 7878 "Filme"))
          (tile (arr "Lidarr" 8686 "Musik"))
        ];
      }
      {
        System = [
          (tile {
            name = "Beszel";
            p = 8090;
            description = "Monitoring";
            icon = "beszel.svg";
            widget = {
              type = "beszel";
              # Must be a Beszel *superuser* (log in at :8090/_/ to check),
              # username is its e-mail address.
              username = "{{HOMEPAGE_VAR_BESZEL_USER}}";
              password = "{{HOMEPAGE_VAR_BESZEL_PASS}}";
              # Required for Beszel 0.9+: without it the widget logs in via
              # the old /api/admins endpoint and gets a 404.
              version = 2;
            };
          })
        ];
      }
    ];

    bookmarks = [
      {
        Admin = [
          {
            Router = [
              {
                href = "http://192.168.1.1";
                abbr = "RT";
              }
            ];
          }
          {
            Cloudflare = [
              {
                href = "https://dash.cloudflare.com";
                abbr = "CF";
              }
            ];
          }
          {
            "Proton VPN" = [
              {
                href = "https://account.protonvpn.com";
                abbr = "PV";
              }
            ];
          }
        ];
      }
    ];
  };

  networking.firewall.extraInputRules = ''
    ip saddr ${lan.v4} tcp dport ${toString port} accept comment "Homepage from LAN (v4)"
    ip6 saddr ${lan.v6} tcp dport ${toString port} accept comment "Homepage from LAN (v6)"
    iifname "wg0" ip saddr ${lan.vpn} tcp dport ${toString port} accept comment "Homepage from VPN"
  '';
}
