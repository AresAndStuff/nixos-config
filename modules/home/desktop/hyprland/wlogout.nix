{ theme, assets, pkgs, ... }:

let
  layout = pkgs.writeText "wlogout-layout" ''
    {
      "label": "logout",
      "action": "hyprlock"
    }
    {
      "label": "suspend",
      "action": "systemctl suspend"
    }
    {
      "label": "reboot",
      "action": "systemctl reboot"
    }
    {
      "label": "shutdown",
      "action": "systemctl poweroff"
    }
  '';

  style = pkgs.writeText "wlogout-style.css" ''
    window {
      background-color: alpha(${theme.bg}, 0.9);
    }

    button {
      color: ${theme.text};
      background-color: transparent;
      box-shadow: none;
      background-repeat: no-repeat;
      background-position: center;
      background-size: 30%;
      border-radius: 80px;
      margin: 120px 10px;
      transition: background-color 100ms ease, background-size 100ms ease;
    }

    button:focus {
      outline: 2px solid ${theme.accent};
      outline-offset: -40px;
      background-color: transparent;
      background-size: 30%;
    }

    button:hover {
      color: ${theme.bg};
      background-color: ${theme.accent};
      background-size: 50%;
      outline: none;
    }

    #logout   { background-image: image(url("${assets}/logout.png")); }
    #suspend  { background-image: image(url("${assets}/suspend.png")); }
    #reboot   { background-image: image(url("${assets}/restart.png")); }
    #shutdown { background-image: image(url("${assets}/shutdown.png")); }
  '';

  wlogout-menu = pkgs.writeShellScriptBin "wlogout-menu" ''
    exec ${pkgs.wlogout}/bin/wlogout -b 4 -l ${layout} -C ${style} "$@"
  '';
in
{
  home.packages = [ pkgs.wlogout wlogout-menu ];
}