{
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    # Auth agent
    gnome-keyring

    # Utilities
    libnotify
    pavucontrol
    brightnessctl
    htop
    gvfs
    wget
    curl
    ananicy
    libva
    libva-utils
    playerctl
    gcc
    nodejs

    # utils2
    bluez
    blueman
    p7zip
    kitty
    keyd
    git
    gsettings-desktop-schemas

    # nix stuff
    inputs.nix-alien.packages.${stdenv.hostPlatform.system}.default
    home-manager
    (pkgs.writeShellApplication {
      name = "ns";
      runtimeInputs = with pkgs; [
        fzf
        nix-search-tv
      ];
      text = builtins.readFile "${pkgs.nix-search-tv.src}/nixpkgs.sh";
    })
  ];
}
