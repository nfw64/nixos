//@ pragma UseQApplication
//@ pragma Env QT_QPA_PLATFORMTHEME=gtk3
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma Env QSG_RENDER_LOOP=threaded
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000

import Quickshell
import Quickshell.Io
import QtQuick
import "bar"
import "applauncher"
import "notifications"
import "wallpaper"
import "media"
import "osd"

ShellRoot {
    // Stop quickshell from auto-reloading whenever matugen writes to Theme.qml
    settings.watchFiles: false
    Theme {
        id: ts
    }
    Bar {
        theme: ts
    }
    AppLauncher {
        theme: ts
    }
    NotificationPopup {
        theme: ts
    }
    WallpaperManager {
        theme: ts
    }
    MediaControl {
        theme: ts
    }
    OSD {
        theme: ts
    }
}
