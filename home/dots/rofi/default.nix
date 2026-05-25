{
  config,
  pkgs,
  ...
}:

{
  home.packages = [
    pkgs.rofi
  ];
  xdg.configFile."rofi/config.rasi".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home/dots/rofi/config.rasi";
}
