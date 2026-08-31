{ ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings.General = {
      # Battery levels for headsets/controllers (needs BlueZ experimental)
      Experimental = true;
      # Reconnect faster after suspend / device power-on
      FastConnectable = true;
    };
  };

  # blueman-manager (GUI) + blueman-mechanism (system dbus service).
  # Plasma uses its own bluedevil applet; see home/desktop for the split.
  services.blueman.enable = true;
}