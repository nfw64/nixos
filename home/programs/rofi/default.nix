{
  config,
  ...
}:

{
  xdg.configFile."rofi/config.rasi".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/config/programs/rofi/config.rasi";
}
