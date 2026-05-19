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
    xwayland-satellite
    awww
    bibata-cursors
    (papirus-icon-theme.override {
      color = "bluegrey";
    })

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
    tmux
    sesh

    #anime stuff
    inputs.jerry.packages.${stdenv.hostPlatform.system}.default
    openssl # jerry needs this for allanime
    chafa # image preview

    floorp-bin
    easyeffects
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
