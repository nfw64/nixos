{
  description = "nixos-flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
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
    kari = {
      url = "github:Dhairya3391/kari";
      flake = false;
    };
    minecraft-plymouth = {
      url = "github:nikp123/minecraft-plymouth-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    qml-language-server = {
      url = "github:cushycush/qml-language-server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    sharedOverlays = [
      (final: prev: {
        pkgsi686Linux =
          prev.pkgsi686Linux
          // {
            openldap = prev.pkgsi686Linux.openldap.overrideAttrs (oldAttrs: {
              doCheck = false;
            });
          };
      })
    ];
  in {
    nixosConfigurations.nixos-myriad = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit self inputs;};
      modules = [
        {nixpkgs.hostPlatform = "x86_64-linux";}
        ./hosts/default/configuration.nix
        {
          nixpkgs.overlays = sharedOverlays;
          nixpkgs.config.allowUnfree = true;
        }

        home-manager.nixosModules.home-manager
        inputs.minegrub-world-sel-theme.nixosModules.default
        inputs.nix-index-database.nixosModules.default
      ];
    };
  };
}
