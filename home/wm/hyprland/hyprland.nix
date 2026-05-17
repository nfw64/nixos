{
  pkgs,
  config,
  lib,
  ...
}:
{
  Hyprland.useHyprland = true;

  xdg.configFile.hypr = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos/home/wm/hyprland/hypr";
    recursive = true;
  };

  home.packages = with pkgs; [
    hyprlock
    wlogout
    hyprpolkitagent
    hypridle
    xdg-desktop-portal-gtk # change
    xdg-desktop-portal # change
    xwayland-satellite # change
  ];

  # todo
}
