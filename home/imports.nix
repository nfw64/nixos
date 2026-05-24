{
  config,
  ...
}:
let
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
in

{
  imports = [
    ./wm/niri/niri.nix
    ./programs/cava/default.nix
    ./programs/matugen/default.nix
    ./programs/nvim/default.nix
    ./programs/quickshell/default.nix
    ./programs/thunar/default.nix
    ./programs/tmux/default.nix
    ./programs/zsh/zsh.nix
    ./programs/yazi.nix
  ];

  xdg.configFile = builtins.mapAttrs (name: subpath: {
    source = create-symlink "${dotfiles}/home/configs/${subpath}";
    recursive = true;
  }) configs;

  home.file = builtins.mapAttrs (name: subpath: {
    source = create-symlink "${dotfiles}/assets/${subpath}";
  }) homeFiles;

}
