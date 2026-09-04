local HOME = os.getenv("HOME")

-- General Envs
hl.env("EDITOR", "nvim")
hl.env("TERMINAL", "kitty")
hl.env("BROWSER", "firefox-beta")
hl.env("SCRIPTS", HOME .. "/.local/bin")

-- FORCE AMD iGPU (Crucial for D3cold)
-- Find exact path using `ls /dev/dri/by-path/`
hl.env("AQ_DRM_DEVICES", "/dev/dri/card1")
-- hl.env("__EGL_VENDOR_LIBRARY_FILENAMES", "/run/current-system/sw/share/glvnd/egl_vendor.d/50_mesa.json")

-- Disable realtime priority since you use ananicy-cpp
hl.env("HYPRLAND_NO_RT", "1")

-- Wayland
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("DESKTOP_SESSION", "Hyprland")
hl.env("XCURSOR_THEME", "Firefly")
hl.env("XDG_SESSION_TYPE", "wayland")

-- Qt
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- XDG Paths
hl.env("XDG_STATE_HOME", HOME .. "/.local/state")
hl.env("XDG_DATA_HOME", HOME .. "/.local/share")
hl.env("XDG_CONFIG_HOME", HOME .. "/.config")
hl.env("XDG_CACHE_HOME", HOME .. "/.cache")
hl.env("XDG_PICTURES_DIR", HOME .. "/Media/pictures")
