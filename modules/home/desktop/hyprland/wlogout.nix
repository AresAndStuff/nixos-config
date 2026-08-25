{ theme, assets, pkgs, ... }:

{
  home.packages = [ pkgs.wlogout ];

  xdg.configFile."wlogout/config".text = ''
    [main]
    buttons-per-row=4
  '';

  xdg.configFile."wlogout/layout".text = ''
    {
      "label": "suspend",
      "action": "systemctl suspend"
    }
    {
      "label": "shutdown",
      "action": "systemctl poweroff"
    }
    {
      "label": "reboot",
      "action": "systemctl reboot"
    }
    {
      "label": "logout",
      "action": "hyprlock"
    }
  '';

  xdg.configFile."wlogout/style.css".text = ''
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
    }

    button:hover,
    button:focus {
      color: ${theme.bg};
      background-color: ${theme.accent};
      background-size: 50%;
    }

    #suspend  { background-image: image(url("${assets}/suspend.png")); }
    #shutdown { background-image: image(url("${assets}/shutdown.png")); }
    #logout   { background-image: image(url("${assets}/logout.png")); }
    #reboot   { background-image: image(url("${assets}/restart.png")); }
  '';
}