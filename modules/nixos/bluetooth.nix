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
}
