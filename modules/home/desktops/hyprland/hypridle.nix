{ config, lib, ... }:

# Suspend after 30 minutes without input. Video players and games hold an
# idle inhibitor, so they keep the machine awake while they play.
let
  hyprlock = lib.getExe config.programs.hyprlock.package;
in
{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || ${hyprlock}";
        before_sleep_cmd = "loginctl lock-session"; # wake up to the lock screen
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 1800; # seconds
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
