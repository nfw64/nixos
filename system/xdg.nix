{ pkgs, ... }:
{
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    config = {
      common = {
        # Default to GTK for standard desktop features (like file dialogs)
        default = [ "gtk" ];

        # Explicitly force file choices to use the generic GTK interface
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];

        # Keep GNOME active only for features Niri strictly relies on
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
        "org.freedesktop.impl.portal.Settings" = [ "gnome" ];
      };
    };
  };
}
