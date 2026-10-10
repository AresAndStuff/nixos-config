{
  description = "NixOS configuration with Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mysecrets = {
      url = "git+file:///home/ado/nix-secrets";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      assets = ./assets;
      args = inputs // { inherit assets; };

      mkHost = host: nixpkgs.lib.nixosSystem {
        specialArgs = args;
        modules = [
          ./hosts/${host}/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = args;
              backupFileExtension = "bak";
              users.ado = import ./hosts/${host}/home.nix;
            };
          }
        ];
      };
    in
    {
      nixosConfigurations = {
        nix-desktop = mkHost "desktop";
        nix-laptop = mkHost "laptop";
      };
    };
}