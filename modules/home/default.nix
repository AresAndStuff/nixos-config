{ ... }:

{
  imports = [
    ./theme.nix
    ./cli.nix
    ./packages.nix
    ./librewolf.nix
    ./mpd.nix
    ./desktop
  ];
}