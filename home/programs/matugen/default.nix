{
  config,
  self,
  ...
}:

{
  xdg.configFile."matugen".source =
    config.lib.file.mkOutOfStoreSymlink "${self}/nixos/home/programs/matugen/assets";
}
