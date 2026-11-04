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

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    mysecrets = {
      # git+file only sees committed files: commit new .age files in the
      # secrets repo first, then run `nix flake update mysecrets`.
      url = "git+file:///home/ado/nix-secrets";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      # Extra module arguments, for every host and for Home Manager
      args = inputs // {
        assets = ./assets;
        lan = import ./lan.nix;
      };

      mkHost =
        host:
        nixpkgs.lib.nixosSystem {
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

      mkServer =
        host:
        nixpkgs.lib.nixosSystem {
          specialArgs = args;
          modules = [ ./hosts/${host}/configuration.nix ];
        };
    in
    {
      nixosConfigurations = {
        nix-desktop = mkHost "desktop";
        nix-laptop = mkHost "laptop";
        nix-hs = mkServer "hs";
      };
    };
}
