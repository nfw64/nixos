{
  config,
  pkgs,
  self,
  ...
}:

let
  dotfiles = "${config.home.homeDirectory}/nixos";
  create-symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    kitty = "kitty";
    fastfetch = "fastfetch";
    flameshot = "flameshot";
    Kvantum = "Kvantum";
    qt5ct = "qt5ct";
    qt6ct = "qt6ct";
    "starship.toml" = "starship.toml";
    "nbfc.json" = "nbfc.json";
  };

  homeFiles = {
    ".local/share/themes" = "local/themes";
  };
in

{

  imports = [
    "${self}/home/sharedVars.nix"
    "${self}/home/wm/niri/niri.nix"
    "${self}/home/programs/cava/default.nix"
    "${self}/home/programs/matugen/default.nix"
    "${self}/home/programs/nvim/default.nix"
    "${self}/home/programs/quickshell/default.nix"
    "${self}/home/programs/thunar/default.nix"
    "${self}/home/programs/tmux/default.nix"
    "${self}/home/programs/zsh/zsh.nix"
    "${self}/home/programs/yazi.nix"

    ./packages.nix
  ];

  programs = {
    zoxide.enable = true;
  };

  home = {
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
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
    };
  };

  gtk = {
    enable = true;

    gtk3.extraCss = ''@import url("file:///home/myriad/.cache/matugen/colors-gtk.css");'';
    gtk4.extraCss = ''@import url("file:///home/myriad/.cache/matugen/colors-gtk.css");'';

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-theme-name = "adw-gtk3-dark";
      gtk-icon-theme-name = "Papirus-Dark";
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      gtk-theme-name = "adw-gtk3-dark";
      gtk-icon-theme-name = "Papirus-Dark";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
  };

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create-symlink "${dotfiles}/home/configs/${subpath}";
    recursive = true;
  }) configs;

  home.file = builtins.mapAttrs (name: subpath: {
    source = create-symlink "${dotfiles}/assets/${subpath}";
  }) homeFiles;
}
