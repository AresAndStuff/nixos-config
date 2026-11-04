{ ... }:

# Seerr: request page (search a film/show, "request", it goes to Radarr/Sonarr).
# Was Jellyseerr; in 26.05 the module is services.seerr.
let
  port = 5055;
in
{
  services.seerr = {
    enable = true;
    inherit port;
  };

  homelab.lanTcpPorts = [ port ];
}
