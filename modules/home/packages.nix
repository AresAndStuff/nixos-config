{ pkgs, ... }:
let
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
  home.packages = with pkgs; [
    wl-clipboard
    slurp
    grim
    vscodium
    fastfetch
    discord
    onlyoffice-desktopeditors
    libreoffice
    anki
    hyprpaper
    libnotify
    sound-theme-freedesktop
    wlogout
    hyprlock
    swaynotificationcenter
    vlc-scaled
    rmpc
    ungoogled-chromium
    playerctl
  ];
}
