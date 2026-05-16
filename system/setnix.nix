{
  config,
  inputs,
  lib,
  ...
}:
{
  nix = {
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 5d";
    };
    settings = {
      max-jobs = "auto";
      cores = 0;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://cache.garnix.io"
        "https://nix-community.cachix.org"
        "https://attic.xuyh0120.win/lantian"
        "https://niri.cachix.org"

      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      ];
      trusted-users = [
        "root"
        "@wheel"
        "myriad"
      ];
    };
  };
}
