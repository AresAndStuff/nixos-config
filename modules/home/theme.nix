{ lib, ... }:

let
  colors = {
    bg         = "#1a1a1a";
    surface    = "#222222";
    surfaceAlt = "#2c2c2c";
    text       = "#dddddd";
    subtext    = "#999999";
    muted      = "#555555";
    accent     = "#a89984";
    red        = "#ff5555";
    green      = "#89b482";
  };
in
{
  _module.args = {
    theme = colors // {
      font = "JetBrainsMono Nerd Font";
      withAlpha = color: aa: "rgba(${lib.removePrefix "#" color}${aa})";
    };
  };
}
