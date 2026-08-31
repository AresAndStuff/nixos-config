{ ... }:

{
  imports = [
    ./theme.nix
    ./rmpc.nix
    ./cli.nix
    ./ssh.nix
    ./dev.nix
    ./packages.nix
    ./librewolf.nix
    ./mpd.nix
    ./desktop
  ];
}
