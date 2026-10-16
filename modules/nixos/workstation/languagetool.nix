{
  lib,
  pkgs,
  config,
  ...
}:

let
  frontPort = 8081; # what the add-on talks to
  backPort = 8082; # where LanguageTool actually runs
in
{
  services.languagetool = {
    enable = true;
    port = backPort;
    public = false;
    allowOrigin = "*";
    settings.cacheSize = 1000;
    jvmOptions = [ "-Xmx1g" ];
  };

  systemd.services.languagetool = {
    wantedBy = lib.mkForce [ ];
    unitConfig.StopWhenUnneeded = true;
    # waits for the JVM instead of hitting a closed port
    serviceConfig.ExecStartPost = pkgs.writeShellScript "languagetool-wait" ''
      until ${pkgs.curl}/bin/curl -sf http://127.0.0.1:${toString backPort}/v2/languages >/dev/null; do
        sleep 0.5
      done
    '';
  };

  systemd.sockets.languagetool-proxy = {
    wantedBy = [ "sockets.target" ];
    listenStreams = [ "127.0.0.1:${toString frontPort}" ];
  };

  systemd.services.languagetool-proxy = {
    requires = [ "languagetool.service" ];
    after = [ "languagetool.service" ];
    serviceConfig = {
      ExecStart = "${config.systemd.package}/lib/systemd/systemd-socket-proxyd --exit-idle-time=60s 127.0.0.1:${toString backPort}";
      DynamicUser = true;
      PrivateNetwork = false;
    };
  };
}
