_: {
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "radeonsi";

    __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json";
    VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    __GLX_VENDOR_LIBRARY_NAME = "mesa";
    AQ_DRM_DEVICES = "/dev/dri/card1";

    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    QQT_QPA_PLATFORM = "wayland;xcb";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    GDK_BACKEND = "wayland,x11";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  environment.variables = {
    TERMINAL = "kitty";
  };
}
