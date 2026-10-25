{
  config,
  lib,
  pkgs,
  ...
}:

# qBittorrent runs in its own network namespace "proton". Its only way out
# is the Proton WireGuard tunnel; without the tunnel there is no route at all
# (kill switch). Everything else on the server uses the normal connection.
let
  ns = "proton";
  hostVeth = "vproton0"; # host side,      10.200.0.1
  nsVeth = "vproton1"; # namespace side, 10.200.0.2
  qbitAddr = "10.200.0.2";
  webui = config.services.qbittorrent.webuiPort;
  gateway = "10.2.0.1"; # Proton: DNS and NAT-PMP

  # qBittorrent settings that must not get lost. Applied through the API on
  # every start, so the web UI stays writable (serverConfig would make the
  # whole qBittorrent.conf read-only). Change them here, not in the UI.
  qbitPrefs = {
    # Seeding limits: whichever is reached first stops the torrent
    max_ratio_enabled = true;
    max_ratio = 1;
    max_seeding_time_enabled = true;
    max_seeding_time = 10080; # minutes = 7 days
    max_inactive_seeding_time_enabled = true;
    max_inactive_seeding_time = 1440; # minutes = 1 day
    max_ratio_act = 0; # 0 = stop torrent, the *arrs clean up

    # What the *arrs rely on
    save_path = "/srv/data/torrents";
    auto_tmm_enabled = true; # categories use their own paths
    upnp = false; # never open ports on the router
  };

  netnsUp = pkgs.writeShellApplication {
    name = "netns-${ns}-up";
    runtimeInputs = [ pkgs.iproute2 ];
    text = ''
      ip netns del ${ns} 2>/dev/null || true
      ip link del ${hostVeth} 2>/dev/null || true

      ip netns add ${ns}
      ip -n ${ns} link set lo up

      # veth pair, so the host can reach the web UI
      ip link add ${hostVeth} type veth peer name ${nsVeth}
      ip link set ${nsVeth} netns ${ns}
      ip addr add 10.200.0.1/30 dev ${hostVeth}
      ip link set ${hostVeth} up
      ip -n ${ns} addr add ${qbitAddr}/30 dev ${nsVeth}
      ip -n ${ns} link set ${nsVeth} up
    '';
  };

  # Proton hands out a port via NAT-PMP that has to be renewed every minute.
  # When it changes, qBittorrent gets the new one.
  natpmp = pkgs.writeShellApplication {
    name = "proton-natpmp";
    runtimeInputs = with pkgs; [
      libnatpmp
      curl
      gawk
    ];
    text = ''
      # qBittorrent is "started" before its web UI listens
      until curl -sf http://127.0.0.1:${toString webui}/api/v2/app/version >/dev/null; do
        sleep 2
      done
      curl -sf --data-urlencode ${lib.escapeShellArg "json=${builtins.toJSON qbitPrefs}"} \
        http://127.0.0.1:${toString webui}/api/v2/app/setPreferences
      echo "qBittorrent preferences applied"
      last=""
      while true; do
        natpmpc -a 1 0 udp 60 -g ${gateway} >/dev/null
        port=$(natpmpc -a 1 0 tcp 60 -g ${gateway} | awk '/Mapped public port/ { print $4 }')
        if [ -z "$port" ]; then
          echo "NAT-PMP returned no port" >&2
          exit 1
        fi
        if [ "$port" != "$last" ]; then
          curl -sf --data-urlencode "json={\"listen_port\":$port}" \
            http://127.0.0.1:${toString webui}/api/v2/app/setPreferences
          echo "qBittorrent listen port -> $port"
          last=$port
        fi
        sleep 45
      done
    '';
  };

  inNamespace = {
    NetworkNamespacePath = "/run/netns/${ns}";
    BindReadOnlyPaths = [
      # DNS through the tunnel, not the router
      "/etc/netns/${ns}/resolv.conf:/etc/resolv.conf"
      # otherwise glibc asks nscd, which resolves outside the namespace (DNS leak)
      "/var/empty:/run/nscd"
    ];
  };
in
{
  systemd.services."netns-${ns}" = {
    description = "Network namespace for qBittorrent over Proton VPN";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = lib.getExe netnsUp;
      ExecStop = "${pkgs.iproute2}/bin/ip netns del ${ns}";
    };
  };

  environment.etc."netns/${ns}/resolv.conf".text = "nameserver ${gateway}\n";

  # Interface lives in the namespace, its UDP socket stays outside
  networking.wireguard.interfaces.proton = {
    interfaceNamespace = ns;
    ips = [ "10.2.0.2/32" ];
    privateKeyFile = config.age.secrets.proton-wg.path;
    peers = [
      {
        publicKey = "VNNO5MYorFu1UerHvoXccW6TvotxbJ1GAGJKtzM9HTY=";
        endpoint = "185.159.157.23:51820";
        allowedIPs = [ "0.0.0.0/0" ]; # default route, only inside the namespace
        persistentKeepalive = 25;
      }
    ];
  };

  systemd.services.wireguard-proton = {
    bindsTo = [ "netns-${ns}.service" ];
    after = [ "netns-${ns}.service" ];
  };

  # Tunnel gone -> qBittorrent stops
  systemd.services.qbittorrent = {
    bindsTo = [ "wireguard-proton.service" ];
    after = [ "wireguard-proton.service" ];
    serviceConfig = inNamespace;
  };

  systemd.services.proton-natpmp = {
    description = "Proton VPN port forwarding for qBittorrent";
    wantedBy = [ "qbittorrent.service" ];
    bindsTo = [ "qbittorrent.service" ];
    after = [ "qbittorrent.service" ];
    serviceConfig = inNamespace // {
      ExecStart = lib.getExe natpmp;
      DynamicUser = true;
      Restart = "always";
      RestartSec = 10;
    };
  };

  # Web UI on host port 8080 -> qBittorrent in the namespace.
  # Same pattern as LanguageTool; the *arrs keep using localhost:8080.
  systemd.sockets.qbittorrent-proxy = {
    wantedBy = [ "sockets.target" ];
    listenStreams = [ (toString webui) ];
  };
  systemd.services.qbittorrent-proxy = {
    requires = [ "qbittorrent.service" ];
    after = [ "qbittorrent.service" ];
    serviceConfig = {
      ExecStart = "${config.systemd.package}/lib/systemd/systemd-socket-proxyd ${qbitAddr}:${toString webui}";
      DynamicUser = true;
    };
  };

  networking.networkmanager.unmanaged = [ hostVeth ];
}
