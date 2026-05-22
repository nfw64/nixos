{
  pkgs,
  config,
  ...
}:
{
  Niri.useNiri = true;

  xdg.configFile = {
    swayidle = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home/wm/niri/configs/swayidle";
      recursive = true;
    };
    niri = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home/wm/niri/niri";
      recursive = true;
    };
  };

  home.packages = with pkgs; [
    wlogout
    polkit_gnome
    swayidle
    xdg-desktop-portal-gtk
    xdg-desktop-portal
    xwayland-satellite
  ];
}
