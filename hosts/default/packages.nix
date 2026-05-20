{
  pkgs,
  ...
}:

let
  jerryScript = pkgs.fetchurl {
    url = "https://github.com/justchokingaround/jerry/raw/main/jerry.sh";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

in
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
    cbonsai

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
    (pkgs.writeShellApplication {
      name = "jerry";

      runtimeInputs = with pkgs; [
        grep
        sed
        curl
        fzf
        mpv
        openssl
        rofi
        ueberzugpp
        jq
      ];

      text = ''
        # Run the safely cached script and pass all arguments cleanly
        bash "${jerryScript}" "$@"
      '';
    })

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
