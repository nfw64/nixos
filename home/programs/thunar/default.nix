{
  config,
  ...
}:

{
  xdg.configFile."Thunar".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home/programs/thunar/narnar";
}
