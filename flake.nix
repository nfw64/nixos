{
  description = "nixos-flakes";

  inputs = {
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    nix-gaming.url = "github:fufexan/nix-gaming";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    minegrub-world-sel-theme.url = "github:Lxtharia/minegrub-world-sel-theme";
    minegrub-world-sel-theme.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-index-database,
      nixpkgs,
      home-manager,
      nix-cachyos-kernel,
      minegrub-world-sel-theme,
      nur,
      ...
    }:
    {
      nixosConfigurations.nixos-myriad = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit self inputs; };
        system = "x86_64-linux";
        modules = [
          ./hosts/default/configuration.nix
          inputs.minegrub-world-sel-theme.nixosModules.default
          {
            nixpkgs.overlays = [
              (final: prev: {
                pkgsi686Linux = prev.pkgsi686Linux // {
                  openldap = prev.pkgsi686Linux.openldap.overrideAttrs (oldAttrs: {
                    doCheck = false;
                  });
                };
              })
              nix-cachyos-kernel.overlays.pinned
            ];
          }
          home-manager.nixosModules.home-manager
          nix-index-database.nixosModules.default
          { programs.nix-index-database.comma.enable = true; }
        ];
      };
    };
}
