{ ... }:

{
  imports = [
    ./theme.nix
    ./rmpc.nix
    ./cli.nix
    ./packages.nix
    ./librewolf.nix
    ./mpd.nix
    ./desktop
  ];
}