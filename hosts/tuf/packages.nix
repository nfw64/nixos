{pkgs, ...}: {
  home.packages = with pkgs; [
    #utils
    cliphist
    nh
    wtype
    ffmpeg
    wine

    # rice
    gtk3
    glib
    matugen
    quickshell
    awww
    trash-cli

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
    ouch
    fzf-git-sh
    bat
    jq
    fd
    tmux
    sesh
    nix-search
    nurl
    jq
    openssl
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
