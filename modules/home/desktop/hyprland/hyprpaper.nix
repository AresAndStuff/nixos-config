{ assets, pkgs, ... }:

{
  home.packages = [ pkgs.hyprpaper ];

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = [ "${assets}/wallpaper.png" ];
      wallpaper = [ 
        {
          monitor = "";
          path = "${assets}/wallpaper.png";
        }
       ];
    };
  };
}