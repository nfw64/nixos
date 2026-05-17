{
  pkgs,
  config,
  ...
}:

{
  Niri.useNiri = true;

  xdg.configFile.niri = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home/wm/niri/niri";
    recursive = true;
  };

  home.packages = with pkgs; [
    swaylock
    wlogout
    polkit_gnome
    swayidle
    xdg-desktop-portal-gtk
    xdg-desktop-portal
    xwayland-satellite
  ];
}
