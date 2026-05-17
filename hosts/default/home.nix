{
  config,
  pkgs,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos";
  create-symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    swaylock = "swaylock";
    swayidle = "swayidle";
    wlogout = "wlogout";
    quickshell = "quickshell";
    kitty = "kitty";
    cava = "cava";
    fastfetch = "fastfetch";
    flameshot = "flameshot";
    Kvantum = "Kvantum";
    matugen = "matugen";
    nwg-look = "nwg-look";
    qt5ct = "qt5ct";
    qt6ct = "qt6ct";
    Thunar = "Thunar";
    nvim = "nvim";
    # "gtk-3.0" = "gtk-3.0";
    # "gtk-4.0" = "gtk-4.0";
    "starship.toml" = "starship.toml";
    "nbfc.json" = "nbfc.json";
  };

  homeFiles = {
    ".local/share/themes" = "local/themes";
  };
in

{

  imports = [
    ../../home/shell/zsh.nix
    ../../home/sharedVars.nix
    ../../home/wm/niri/niri.nix
    ../../home/programs/yazi.nix

    ./packages.nix
  ];

  programs = {
    zoxide.enable = true;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override {
        color = "bluegrey";
      };
    };
  };

  home = {
    pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };
    sessionPath = [
      "${dotfiles}/assets/scripts"
    ];

    username = "myriad";
    homeDirectory = "/home/myriad";
    stateVersion = "25.11";
    sessionVariables = {
      EDITOR = "nvim";
      TERMINAL = "kitty";
      BROWSER = "firefox";
      NH_FLAKE = "/home/myriad/nixos/";
      QT_QPA_PLATFORMTHEME = "qt6ct";
    };
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create-symlink "${dotfiles}/home/configs/${subpath}";
    recursive = true;
  }) configs;
  home.file = builtins.mapAttrs (name: subpath: {
    source = create-symlink "${dotfiles}/assets/${subpath}";
  }) homeFiles;
}
