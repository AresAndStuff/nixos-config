{ ... }:

{
  imports = [
    ./theme.nix
    ./rmpc.nix
    ./cli.nix
    ./dev.nix
    ./packages.nix
    ./librewolf.nix
    ./mpd.nix
    ./desktop
  ];
}