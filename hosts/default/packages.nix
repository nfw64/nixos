{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = with pkgs; [

    #utils
    cliphist
    nh
    wtype
    ffmpeg

    # rice
    gtk3
    glib
    matugen
    quickshell
    awww

    eza
    qt6Packages.qt6ct
    fastfetch
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum

    # gaming lol
    protonplus
    mangohud

    #cli tools
    fzf
    fzf-git-sh
    bat
    jq
    fd
    tmux
    sesh
    nix-search

    #anime stuff
    inputs.curd.packages.${stdenv.hostPlatform.system}.default
    openssl
    ueberzugpp
    jq
    chafa

    vesktop
    meld
    easyeffects
    pear-desktop
    lutris
    bitwarden-desktop
    python3
    wl-clipboard
    grim
    slurp
    ripgrep
    nodejs
    thunar
    mpv
  ];
}
