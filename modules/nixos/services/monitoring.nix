{
  config,
  lib,
  pkgs,
  lan,
  ...
}:

# Beszel: hub (web UI + history) and agent (collects this host's metrics).
# The agent needs a key and token that only exist once the hub is running,
# so on a fresh install deploy hub-only first (agentReady = false), add the
# system in the hub, store KEY/TOKEN with agenix, then flip it to true.
let
  agentReady = true;
  hubPort = 8090;
in
{
  services.beszel.hub = {
    enable = true;
    host = "0.0.0.0"; # the firewall below limits it to LAN + VPN
    port = hubPort;
  };
  systemd.services.beszel-hub.environment.APP_URL = "http://192.168.1.195:${toString hubPort}";

  services.beszel.agent = lib.mkIf agentReady {
    enable = true;
    # KEY="ssh-ed25519 AAAA…"  (quotes: the value contains a space)
    # TOKEN=…
    environmentFile = config.age.secrets.beszel-agent-env.path;
    environment = {
      HUB_URL = "http://127.0.0.1:${toString hubPort}";
      EXTRA_FILESYSTEMS = "/srv/data"; # the USB disk, next to /
      INTEL_GPU_DEVICE = "drm:/dev/dri/card0"; # don't let the agent search for the GPU
    };
    # GPU stats (i915): the agent runs intel_gpu_top, which has to be on its PATH
    extraPath = [ pkgs.intel-gpu-tools ];
  };

  # intel_gpu_top reads the GPU's perf counters. The module's sandbox blocks
  # that in four places, so the GPU never shows up without these overrides:
  systemd.services.beszel-agent.serviceConfig = lib.mkIf agentReady {
    # 1. the agent isn't root: grant perf access. Both lines are needed, an
    #    ambient capability missing from the bounding set is silently dropped.
    AmbientCapabilities = [ "CAP_PERFMON" ];
    CapabilityBoundingSet = [ "CAP_PERFMON" ];
    # 2. PrivateUsers puts the agent in a user namespace, where CAP_PERFMON
    #    does not count for the host's perf counters
    PrivateUsers = lib.mkForce false;
    # 3. PrivateDevices hides /dev/dri; open it up, but only for the GPU
    PrivateDevices = lib.mkForce false;
    DeviceAllow = [
      "/dev/dri/card0 rw"
      "/dev/dri/renderD128 rw"
    ];
    SupplementaryGroups = [
      "video"
      "render"
    ];
    # 4. @system-service doesn't include perf_event_open (it's in @debug)
    SystemCallFilter = [ "perf_event_open" ];
  };
  boot.kernel.sysctl."kernel.perf_event_paranoid" = 2;

  networking.firewall.extraInputRules = ''
    ip saddr ${lan.v4} tcp dport ${toString hubPort} accept comment "Beszel from LAN (v4)"
    ip6 saddr ${lan.v6} tcp dport ${toString hubPort} accept comment "Beszel from LAN (v6)"
    iifname "wg0" ip saddr ${lan.vpn} tcp dport ${toString hubPort} accept comment "Beszel from VPN"
  '';
}
