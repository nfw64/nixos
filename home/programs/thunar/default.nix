{ config, self, ... }:

{
  xdg.configFile."Thunar".source =
    config.lib.file.mkOutOfStoreSymlink "${self}/home/programs/thunar/assets";
}
