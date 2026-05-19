{
  config,
  pkgs,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos";
  create-symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    wlogout = "wlogout";
    tmux = "tmux";
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
    "starship.toml" = "starship.toml";
    "nbfc.json" = "nbfc.json";
  };

  homeFiles = {
    ".local/share/themes" = "local/themes";
  };
in

{

  imports = [
    ../../home/shell/zsh/zsh.nix
    ../../home/sharedVars.nix
    ../../home/wm/niri/niri.nix
    ../../home/programs/yazi.nix

    ./packages.nix
  ];

  programs = {
    zoxide.enable = true;
  };

  home = {
    pointerCursor = {
      gtk.enable = false;
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

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "adw-gtk3-dark";
      icon-theme = "Papirus-Dark";
      cursor-theme = "Bibata-Modern-Ice";
      cursor-size = 24;
      color-scheme = "prefer-dark";
      font-name = "JetBrainsMonoNL Nerd Font SemiBold 11";
    };
  };

  xdg.configFile =
    (builtins.mapAttrs (name: subpath: {
      source = create-symlink "${dotfiles}/home/configs/${subpath}";
      recursive = true;
    }) configs)
    // {
      "gtk-3.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name=adw-gtk3-dark
        gtk-font-name=JetBrainsMonoNL Nerd Font SemiBold 11
        gtk-application-prefer-dark-theme=1
        gtk-cursor-theme-name=Bibata-Modern-Ice
        gtk-cursor-theme-size=24
        gtk-icon-theme-name=Papirus-Dark
      '';

      "gtk-4.0/settings.ini".text = ''
        [Settings]
        gtk-theme-name=adw-gtk3-dark 
        gtk-font-name=JetBrainsMonoNL Nerd Font SemiBold 11
        gtk-application-prefer-dark-theme=1
        gtk-cursor-theme-name=Bibata-Modern-Ice
        gtk-cursor-theme-size=24
        gtk-icon-theme-name=Papirus-Dark
      '';
    };

  home.file = builtins.mapAttrs (name: subpath: {
    source = create-symlink "${dotfiles}/assets/${subpath}";
  }) homeFiles;
}
