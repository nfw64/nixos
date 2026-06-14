{
  pkgs,
  inputs,
  ...
}: {
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
    (pkgs.buildGoModule {
      pname = "kari";
      version = "latest";
      src = inputs.kari;

      subPackages = ["cmd/kari"];

      vendorHash = "sha256-a//13YOUpG3+IMT8X6Lt4z0ceMOJe9D/Mad4QnnN6Ts=";

      nativeBuildInputs = [pkgs.makeWrapper];

      postInstall = ''
        wrapProgram $out/bin/kari \
          --prefix PATH : ${pkgs.lib.makeBinPath [
          pkgs.aria2
          pkgs.mpv
          pkgs.python313Packages.yt-dlp
        ]}
      '';

      meta = {
        description = "Kari — hunt media from the terminal";
        homepage = "https://github.com/Dhairya3391/kari";
        mainProgram = "kari";
      };
    })

    openssl
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
