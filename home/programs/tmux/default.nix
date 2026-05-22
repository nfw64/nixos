{
  config,
  pkgs,
  self,
  ...
}:

{

  home.packages = with pkgs; [
    tmux
    sesh
  ];
  xdg.configFile."tmux".source =
    config.lib.file.mkOutOfStoreSymlink "${self}/home/programs/tmux/assets";
}
