{ pkgs, ... }:

let
  # VLC with 2x Qt scaling, to suit the desktop's monitor
  vlc-scaled = pkgs.symlinkJoin {
    name = "vlc-scaled";
    paths = [ pkgs.vlc ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/vlc --set QT_SCALE_FACTOR 2

      for f in $out/share/applications/*.desktop; do
        target=$(readlink -f "$f")
        rm "$f"
        sed "s|${pkgs.vlc}/bin/|$out/bin/|g" "$target" > "$f"
      done
    '';
  };
in
{
  imports = [
    ../../modules/home
    ../../modules/home/desktops/hyprland
    ../../modules/home/music
  ];

  home.packages = [ vlc-scaled ];

  home.stateVersion = "26.05";
}
