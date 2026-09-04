{config, ...}: let
  dotfiles = "${config.home.homeDirectory}/nixos";
  create-symlink = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    kitty = "kitty";
    fastfetch = "fastfetch";
    Kvantum = "Kvantum";
    qt5ct = "qt5ct";
    qt6ct = "qt6ct";
    "starship.toml" = "starship.toml";
    "nbfc.json" = "nbfc.json";
  };

  homeFiles = {
    ".local/share/themes" = "local/themes";
  };
in {
  imports = [
    # ./wm/niri/niri.nix
    ./wm/hyprland/hyprland.nix
    ./dots/matugen/default.nix
    ./dots/nvim/default.nix
    ./dots/quickshell/default.nix
    ./dots/thunar/default.nix
    ./dots/tmux/default.nix
    ./dots/rofi/default.nix
    ./programs/zsh/zsh.nix
    # ./programs/kari.nix
    ./programs/yazi.nix
    ./programs/firefox.nix
  ];

  xdg.configFile =
    builtins.mapAttrs (name: subpath: {
      source = create-symlink "${dotfiles}/home/dots/${subpath}";
      recursive = true;
    })
    configs;

  home.file =
    builtins.mapAttrs (name: subpath: {
      source = create-symlink "${dotfiles}/assets/${subpath}";
    })
    homeFiles;
}
