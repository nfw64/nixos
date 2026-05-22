_:

{
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    VDPAU_DRIVER = "va_gl";

    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  environment.variables = {
    QT_QPA_PLATFORM = "wayland";
  };
}
