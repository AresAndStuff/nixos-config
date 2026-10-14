{ config, ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = "${config.home.homeDirectory}/Music";
    playlistDirectory = "${config.xdg.dataHome}/mpd/playlists";
    network = {
      listenAddress = "127.0.0.1";
      port = 6600;
    };
    extraConfig = ''
      auto_update "yes"
      bind_to_address "${config.xdg.dataHome}/mpd/socket"

      audio_output {
        type "pipewire"
        name "PipeWire"
      }
    '';
  };

  services.mpd-mpris.enable = true;
}
