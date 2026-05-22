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
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home/programs/tmux/tmux-kun";

}
