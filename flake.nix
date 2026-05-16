{
  description = "nixos-flakes";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    minegrub-world-sel-theme.url = "github:Lxtharia/minegrub-world-sel-theme";
    minegrub-world-sel-theme.inputs.nixpkgs.follows = "nixpkgs";

    yazi.url = "github:sxyazi/yazi";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
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

              inputs.nix-cachyos-kernel.overlays.pinned
              inputs.yazi.overlays.default

            ];
          }
          home-manager.nixosModules.home-manager
          inputs.nix-index-database.nixosModules.default
          { programs.nix-index-database.comma.enable = true; }
        ];
      };
    };
}
