{
  pkgs,
  lib,
  ...
}:

{
  niriImport.useNiri = true;
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
