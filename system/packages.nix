{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    asusctl

    # Auth agent
    gnome-keyring

    # Utilities
    libnotify
    ntfs3g
    pavucontrol
    brightnessctl
    htop
    gvfs
    wget
    curl
    ananicy-cpp
    libva
    libva-utils
    playerctl
    gcc
    nodejs

    # utils2
    bluez
    blueman
    p7zip-rar
    kitty
    keyd
    git
    gsettings-desktop-schemas

    # nix stuff
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
