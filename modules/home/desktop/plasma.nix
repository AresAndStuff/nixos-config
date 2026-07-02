{ config, pkgs, plasma-manager, ... }: {
  imports = [ plasma-manager.homeModules.plasma-manager ];

  programs.plasma = {
    enable = true;
    
    # Appearance
    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      wallpaper = ../../../assets/wallpaper.png;
    };

    # Shortcuts / Hotkeys
    hotkeys.commands."run-alacritty" = {
      name = "Launch Alacritty";
      key = "Ctrl+Alt+T";
      command = "alacritty";
    };

    # Panels & Widgets (Taskbars)
    panels = [
      # 1. Das zentrierte Dock unten
      {
        location = "bottom";
        height = 52;
        floating = true;
        hiding = "dodgewindows";
        lengthMode = "fit"; # Lässt das Dock mitskalieren

        widgets = [
          "org.kde.plasma.icontasks"
        ];
      }

      # 2. Die Statusleiste oben (Top Bar)
      {
        location = "top";
        height = 30;
        floating = false;
        
        widgets = [
          {
            name = "org.kde.plasma.kickoff";
            config.General = {
              icon = "nix-snowflake-white"; # Eigenes Start-Icon
            };
          }
          "org.kde.plasma.panelspacer"   # Schiebt alles danach nach rechts
          "org.kde.plasma.timer"
          # 1. CPU
          {
            name = "org.kde.plasma.systemmonitor";
            config = {
              Appearance.title = "CPU";
              Appearance.chartFace = "org.kde.ksysguard.piechart";
              Sensors.highPrioritySensorIds = "[\"cpu/all/usage\"]";
              Sensors.totalSensors = "[\"cpu/all/usage\"]";
              SensorColors."cpu/all/usage" = "61,174,233";
            };
          }
          # 2. GPU Pie
          {
            name = "org.kde.plasma.systemmonitor";
            config = {
              Appearance.title = "GPU";
              Appearance.chartFace = "org.kde.ksysguard.piechart";
              Sensors.highPrioritySensorIds = "[\"gpu/all/usage\"]";
              Sensors.totalSensors = "[\"gpu/all/usage\"]";
              SensorColors."gpu/all/usage" = "155,89,182";
            };
          }
          # 3. RAM Pie
          {
            name = "org.kde.plasma.systemmonitor";
            config = {
              Appearance.title = "RAM";
              Appearance.chartFace = "org.kde.ksysguard.piechart";
              Sensors.highPrioritySensorIds = "[\"memory/physical/usedPercent\"]";
              Sensors.totalSensors = "[\"memory/physical/usedPercent\"]";
              SensorColors."memory/physical/usedPercent" = "46,204,113";
            };
          }
          "org.kde.plasma.systemtray"    # WLAN, Bluetooth, Audio
          "org.kde.plasma.digitalclock"  # Uhrzeit & Datum ganz rechts
        ];
      }
    ];

    configFile."kwinrc"."Effect-overview"."BorderActivate" = 9;

    # Explicit Window Manager rules or Keybindings
    shortcuts = {
      "kwin" = {
        "Window Quick Tile Left" = "Meta+Left";
        "Window Quick Tile Right" = "Meta+Right";
        "Overview" = "Meta+Tab";
      };
    };
  };
}