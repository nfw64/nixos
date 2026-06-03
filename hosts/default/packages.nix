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
    (pkgs.writeShellApplication {
      name = "jerry";

      runtimeInputs = with pkgs; [
        fzf
        mpv
        openssl
        ueberzugpp
        jq
        chafa
      ];

      text = ''
        # Run the safely cached script and pass all arguments cleanly
        bash "${inputs.jerry}/jerry.sh" "$@"
      '';
    })
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
