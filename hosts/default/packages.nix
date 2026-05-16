{
  pkgs,
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
    gsettings-desktop-schemas
    matugen
    quickshell
    xwayland-satellite
    awww

    eza
    qt6Packages.qt6ct
    fastfetch
    nwg-look
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

    # nvim
    tree-sitter
    neovim

    #nvim lsp stuff and formatter or mmore
    qt6.qtdeclarative
    statix
    nil
    nixpkgs-fmt
    shfmt

    #cli tools
    fzf
    fzf-git-sh
    bat
    jq
    fd

    floorp-bin
    pear-desktop
    lutris
    bitwarden-desktop
    python3
    wl-clipboard
    cava
    grim
    slurp
    zoxide
    ripgrep
    nodejs
    thunar
    mpv
  ];
}
