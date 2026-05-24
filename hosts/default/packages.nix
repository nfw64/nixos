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
    pywalfox-native

    # zsh
    zsh
    pay-respects
    nix-search
    starship
    zinit

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

    #anime stuff
    inputs.curd.packages.${stdenv.hostPlatform.system}.default
    openssl
    ueberzugpp
    jq
    chafa

    floorp-bin
    easyeffects
    pear-desktop
    lutris
    bitwarden-desktop
    python3
    wl-clipboard
    grim
    slurp
    zoxide
    ripgrep
    nodejs
    thunar
    mpv
  ];
}
