{
  description = "nixos-flakes";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";

    };
    minegrub-world-sel-theme = {
      url = "github:Lxtharia/minegrub-world-sel-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi = {
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "nixpkgs/nixos-unstable";
    nix-alien.url = "github:thiagokokada/nix-alien";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
    }:

    let
      sharedOverlays = [
        (final: prev: {
          pkgsi686Linux = prev.pkgsi686Linux // {
            openldap = prev.pkgsi686Linux.openldap.overrideAttrs (oldAttrs: {
              doCheck = false;
            });
          };
        })
        inputs.nix-cachyos-kernel.overlays.pinned
        inputs.yazi.overlays.default
      ];
    in

    {
      nixosConfigurations.nixos-myriad = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self inputs; };
        system = "x86_64-linux";
        modules = [
          ./hosts/default/configuration.nix
          { nixpkgs.overlays = sharedOverlays; }
          home-manager.nixosModules.home-manager
          inputs.minegrub-world-sel-theme.nixosModules.default
          inputs.nix-index-database.nixosModules.default
        ];
      };
      homeConfigurations."myriad" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = sharedOverlays;
        };

        extraSpecialArgs = { inherit self inputs; };
        modules = [
          ./hosts/default/home.nix
        ];
      };
    };
}
