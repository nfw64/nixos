import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import "assets"
import "../"

Scope {
    property var theme: DefaultTheme {}

    IpcHandler {
        target: "logout"

        function toggle(): void {
            layout.isPanelOpen = !layout.isPanelOpen;
        }
    }

    Layout {
        id: layout
        Button {
            command: "loginctl lock-session"
            keybind: Qt.Key_L
            icon: "lock"
        }

        Button {
            command: "loginctl kill-session $XDG_SESSION_ID"
            keybind: Qt.Key_Q
            icon: "logout"
        }

        Button {
            command: "systemctl suspend"
            keybind: Qt.Key_S
            icon: "sleep"
        }

        Button {
            command: "systemctl hibernate"
            keybind: Qt.Key_H
            icon: "hibernate"
        }

        Button {
            command: "systemctl poweroff"
            keybind: Qt.Key_P
            icon: "power"
        }

        Button {
            command: "systemctl reboot"
            keybind: Qt.Key_R
            icon: "restart"
        }
    }
}
