pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Services.Pipewire

Scope {
    id: root
    property var theme: DefaultTheme {}
    property bool barVisible: true

    // MPRIS active player
    property var activePlayer: {
        const players = Mpris.players.values;
        if (!players || players.length === 0)
            return null;
        for (const p of players) {
            if (p.playbackState === MprisPlaybackState.Playing)
                return p;
        }
        return players[0];
    }

    IpcHandler {
        target: "bar"
        function toggle(): void {
            console.log("test");
            console.log(wsData);
        }
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    // Brightness state
    property real brightnessValue: 0
    property real brightnessMax: 1

    FileView {
        id: brightnessFile
        path: ""
        watchChanges: true
        onFileChanged: brightnessReadProc.running = true
    }

    Process {
        id: brightnessReadProc
        command: ["brightnessctl", "get"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                const val = parseInt(text.trim());
                if (!isNaN(val) && root.brightnessMax > 0)
                    root.brightnessValue = val / root.brightnessMax;
            }
        }
    }

    Process {
        id: brightnessSetProc
        running: false
    }

    Process {
        id: backlightDiscovery
        command: ["sh", "-c", "p=$(ls -d /sys/class/backlight/*/brightness 2>/dev/null | head -1); [ -n \"$p\" ] && echo \"$p\" && cat \"${p%brightness}max_brightness\""]
        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                if (lines.length >= 2) {
                    const max = parseInt(lines[1]);
                    if (!isNaN(max) && max > 0)
                        root.brightnessMax = max;
                    brightnessFile.path = lines[0];
                    brightnessReadProc.running = true;
                }
            }
        }
    }

    property var wsData: []
    Process {
        id: wsStream
        command: ["niri", "msg", "--json", "event-stream"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                try {
                    var e = JSON.parse(data);
                    if (e.WorkspacesChanged)
                        root.parseWs(e.WorkspacesChanged.workspaces);
                    else if (e.WorkspaceActivated)
                        wsQuery.running = true;
                } catch (_) {}
            }
        }
        onRunningChanged: if (!running)
            wsRestart.start()
    }
    Timer {
        id: wsRestart
        interval: 1500
        onTriggered: {
            wsStream.running = true;
        }
    }

    // Niri workspaces services (niriha)

    Process {
        id: wsQuery
        command: ["niri", "msg", "--json", "workspaces"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    var p = JSON.parse(data);
                    var list = (p.Ok && p.Ok.Workspaces) ? p.Ok.Workspaces : Array.isArray(p) ? p : (p.Ok && Array.isArray(p.Ok)) ? p.Ok : null;
                    if (list)
                        root.parseWs(list);
                } catch (_) {}
            }
        }
        Component.onCompleted: running = true
    }

    function parseWs(list) {
        if (!Array.isArray(list))
            return;

        var a = [];
        for (var i = 0; i < list.length; i++) {
            var w = list[i];
            var isFocused = !!w.is_focused;
            var isOccupied = w.active_window_id != null;

            if (isFocused || isOccupied) {
                a.push({
                    idx: w.idx,
                    id: w.id,
                    focused: isFocused,
                    occupied: isOccupied,
                    urgent: !!w.is_urgent
                });
            }
        }

        a.sort((x, y) => x.idx - y.idx);

        var newData = JSON.stringify(a);
        if (JSON.stringify(root.wsData) !== newData) {
            root.wsData = a;
        }
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            visible: root.barVisible

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 32
            color: "transparent"

            Item {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10

                // Left section:  Workspaces + Now Playing
                Row {
                    id: leftSection
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    // Workspaces
                    Rectangle {
                        id: workspacePill
                        height: 24
                        width: workspaceList.contentWidth + 20
                        radius: 12
                        color: root.theme.bgSurface

                        Behavior on width {
                            NumberAnimation {
                                duration: 250
                                easing.type: Easing.OutQuint
                            }
                        }

                        Rectangle {
                            id: focusHighlighter
                            height: 24
                            radius: 12
                            color: root.theme.accentPrimary
                            z: 1

                            property int focusedIdx: {
                                for (var i = 0; i < root.wsData.length; i++) {
                                    if (root.wsData[i].focused)
                                        return i;
                                }
                                return 0;
                            }

                            x: (focusedIdx * 24) + (focusedIdx * 5) + 10
                            width: 32

                            Behavior on x {
                                NumberAnimation {
                                    duration: 300
                                    easing.type: Easing.OutQuint
                                }
                            }
                        }

                        ListView {
                            id: workspaceList
                            anchors.fill: parent
                            anchors.leftMargin: 10
                            orientation: ListView.Horizontal
                            interactive: false
                            spacing: 5
                            model: root.wsData
                            z: 2

                            delegate: Item {
                                id: wsPill
                                required property var modelData

                                width: modelData.focused ? 32 : 24
                                height: 24

                                Behavior on width {
                                    NumberAnimation {
                                        duration: 300
                                        easing.type: Easing.OutQuint
                                    }
                                }

                                Item {
                                    anchors.fill: parent

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.idx
                                        font.pixelSize: 11
                                        font.family: "Hack Nerd Font"
                                        font.bold: modelData.focused

                                        color: modelData.focused ? root.theme.bgBase : root.theme.textPrimary
                                        Behavior on color {
                                            ColorAnimation {
                                                duration: 300
                                            }
                                        }
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        workspaceSwitcher.command = ["niri", "msg", "action", "focus-workspace", modelData.idx.toString()];
                                        workspaceSwitcher.running = true;
                                    }
                                }
                            }
                        }
                    }

                    Process {
                        id: workspaceSwitcher
                    }

                    // Now Playing
                    Rectangle {
                        height: 24
                        width: nowPlayingContent.width + 16
                        radius: 12
                        color: root.theme.bgSurface
                        visible: root.activePlayer !== null

                        Accessible.role: Accessible.Button
                        Accessible.name: {
                            if (!root.activePlayer)
                                return "No media";
                            const artist = root.activePlayer.trackArtist || "";
                            const title = root.activePlayer.trackTitle || "";
                            return "Now playing: " + (artist ? artist + " - " : "") + title;
                        }

                        Row {
                            id: nowPlayingContent
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 8
                            spacing: 6

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: root.activePlayer && root.activePlayer.isPlaying ? "󰐊" : "󰏤"
                                color: root.theme.accentPrimary
                                font.pixelSize: 14
                                font.family: "Hack Nerd Font"
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: {
                                    if (!root.activePlayer)
                                        return "";
                                    const artist = root.activePlayer.trackArtist || "";
                                    const title = root.activePlayer.trackTitle || "";
                                    return artist ? artist + " - " + title : title;
                                }
                                color: root.theme.textPrimary
                                font.pixelSize: 11
                                font.family: "Hack Nerd Font"
                                elide: Text.ElideRight
                                width: Math.min(implicitWidth, 200)
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.activePlayer.togglePlaying()
                        }
                    }
                }

                // Center section: Window Title (truly centered in bar)
                Item {
                    anchors.centerIn: parent
                    height: parent.height
                    width: Math.max(0, parent.width - 2 * Math.max(leftSection.width, rightSection.width) - 32)

                    Rectangle {
                        height: 24
                        radius: 12
                        color: root.theme.bgSurface

                        width: timeDate.width + 24
                        anchors.centerIn: parent

                        Row {
                            id: timeDate
                            width: childrenRect.width
                            height: parent.height
                            spacing: 8

                            anchors.horizontalCenter: parent.horizontalCenter

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: Time.timeString
                                color: root.theme.textPrimary
                                font.pixelSize: 12
                                font.family: "Hack Nerd Font"
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: Time.dateString
                                color: root.theme.textSecondary
                                font.pixelSize: 12
                                font.family: "Hack Nerd Font"
                            }
                        }
                    }
                }

                // Right section: System Info + System Tray
                Row {
                    id: rightSection
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 8

                    Rectangle {
                        height: 24
                        width: batbrightContent.width + 16
                        radius: 12
                        color: root.theme.bgSurface

                        Row {
                            id: batbrightContent
                            anchors.centerIn: parent
                            spacing: 12

                            Rectangle {
                                height: 24
                                width: volContent.width + 12
                                radius: 12
                                color: root.theme.bgSurface

                                Accessible.role: Accessible.StaticText
                                Accessible.name: {
                                    const sink = Pipewire.defaultAudioSink;
                                    if (!sink || !sink.audio)
                                        return "Volume";
                                    if (sink.audio.muted)
                                        return "Volume: muted";
                                    return "Volume: " + Math.round(sink.audio.volume * 100) + "%";
                                }

                                Row {
                                    id: volContent
                                    anchors.centerIn: parent
                                    spacing: 6

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: {
                                            const sink = Pipewire.defaultAudioSink;
                                            if (!sink || !sink.audio || sink.audio.muted || sink.audio.volume <= 0)
                                                return "󰖁";
                                            if (sink.audio.volume < 0.33)
                                                return "󰕿";
                                            if (sink.audio.volume < 0.66)
                                                return "󰖀";
                                            return "󰕾";
                                        }
                                        color: {
                                            const sink = Pipewire.defaultAudioSink;
                                            if (!sink || !sink.audio || sink.audio.muted)
                                                return root.theme.textMuted;
                                            return root.theme.accentPrimary;
                                        }
                                        font.pixelSize: 14
                                        font.family: "Hack Nerd Font"
                                    }

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: {
                                            const sink = Pipewire.defaultAudioSink;
                                            if (!sink || !sink.audio)
                                                return "–";
                                            if (sink.audio.muted)
                                                return "Mute";
                                            return Math.round(sink.audio.volume * 100) + "%";
                                        }
                                        color: root.theme.textPrimary
                                        font.pixelSize: 11
                                        font.family: "Hack Nerd Font"
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    acceptedButtons: Qt.LeftButton
                                    onClicked: {
                                        const sink = Pipewire.defaultAudioSink;
                                        if (sink && sink.audio)
                                            sink.audio.muted = !sink.audio.muted;
                                    }
                                    onWheel: wheel => {
                                        const sink = Pipewire.defaultAudioSink;
                                        if (!sink || !sink.audio)
                                            return;
                                        const delta = wheel.angleDelta.y > 0 ? 0.05 : -0.05;
                                        sink.audio.volume = Math.max(0, Math.min(1.5, sink.audio.volume + delta));
                                    }
                                }
                            }

                            Rectangle {
                                width: 1
                                height: 12
                                color: root.theme.textMuted
                                opacity: 0.3
                                anchors.verticalCenter: parent.verticalCenter
                            }

                            // Brightness
                            Rectangle {
                                height: 24
                                width: brightContent.width + 12
                                radius: 12
                                color: root.theme.bgSurface
                                visible: brightnessFile.path !== ""

                                Accessible.role: Accessible.StaticText
                                Accessible.name: "Brightness: " + Math.round(root.brightnessValue * 100) + "%"

                                Row {
                                    id: brightContent
                                    anchors.centerIn: parent
                                    spacing: 6

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "󰃠"
                                        color: root.theme.accentPrimary
                                        font.pixelSize: 14
                                        font.family: "Hack Nerd Font"
                                    }

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: Math.round(root.brightnessValue * 100) + "%"
                                        color: root.theme.textPrimary
                                        font.pixelSize: 11
                                        font.family: "Hack Nerd Font"
                                    }
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onWheel: wheel => {
                                        brightnessSetProc.command = wheel.angleDelta.y > 0 ? ["brightnessctl", "set", "5%+"] : ["brightnessctl", "set", "5%-"];
                                        brightnessSetProc.running = true;
                                    }
                                }
                            }
                        }
                    }
                    Rectangle {
                        height: 24
                        width: systemInfoContent.width + 16
                        radius: 12
                        color: root.theme.bgSurface

                        Row {
                            id: systemInfoContent
                            anchors.centerIn: parent
                            spacing: 12

                            readonly property color batteryColor: {
                                if (SystemInfo.batteryCharging)
                                    return root.theme.accentGreen;
                                if (SystemInfo.batteryLevelRaw > 20)
                                    return root.theme.batteryGood;
                                if (SystemInfo.batteryLevelRaw > 10)
                                    return root.theme.batteryWarning;
                                return root.theme.batteryCritical;
                            }

                            // CPU
                            Rectangle {
                                height: 24
                                width: cpuContent.width + 12
                                radius: 12
                                color: root.theme.bgSurface
                                Accessible.role: Accessible.StaticText
                                Accessible.name: "CPU: " + SystemInfo.cpuUsage

                                Row {
                                    id: cpuContent
                                    anchors.centerIn: parent
                                    spacing: 6

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: "󰻠"
                                        color: root.theme.accentPrimary
                                        font.pixelSize: 14
                                        font.family: "Hack Nerd Font"
                                    }
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: SystemInfo.cpuUsage
                                        color: root.theme.textPrimary
                                        font.pixelSize: 11
                                        font.family: "Hack Nerd Font"
                                    }
                                }
                            }

                            // Network
                            Rectangle {
                                id: netPill
                                height: 24
                                radius: 12
                                color: root.theme.accentPrimary

                                property bool isConnected: SystemInfo.networkType !== "disconnected"

                                opacity: isConnected ? 1.0 : 0.0
                                scale: isConnected ? 1.0 : 0.8

                                width: isConnected ? (netContent.width + 12) : 0

                                Behavior on width {
                                    NumberAnimation {
                                        duration: 400
                                        easing.type: Easing.OutExpo
                                    }
                                }
                                Behavior on opacity {
                                    NumberAnimation {
                                        duration: 300
                                    }
                                }
                                Behavior on scale {
                                    NumberAnimation {
                                        duration: 400
                                        easing.type: Easing.OutBack
                                    }
                                }

                                clip: true

                                Accessible.role: Accessible.StaticText
                                Accessible.name: {
                                    if (SystemInfo.networkType === "ethernet")
                                        return "Network: Ethernet";
                                    if (SystemInfo.networkType === "wifi")
                                        return "Network: WiFi " + SystemInfo.networkInfo;
                                    return "Network: Disconnected";
                                }

                                Row {
                                    id: netContent
                                    anchors.centerIn: parent
                                    spacing: 6
                                    opacity: netPill.isConnected ? 1.0 : 0.0
                                    Behavior on opacity {
                                        NumberAnimation {
                                            duration: 150
                                        }
                                    }

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: {
                                            if (SystemInfo.networkType === "ethernet")
                                                return "󰈀";
                                            if (SystemInfo.networkType === "wifi")
                                                return "󰖩";
                                            return "󰖪";
                                        }
                                        color: root.theme.bgSurface
                                        font.pixelSize: 14
                                        font.family: "Hack Nerd Font"
                                    }
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: SystemInfo.networkInfo
                                        color: root.theme.bgSurface
                                        font.pixelSize: 11
                                        font.family: "Hack Nerd Font"
                                        visible: text !== ""
                                    }
                                }
                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: {
                                        nmEditor.running = true;
                                    }
                                }
                                Process {
                                    id: nmEditor
                                    command: ["nm-connection-editor"]
                                    running: false
                                }
                            }

                            // Battery
                            Rectangle {
                                height: 24
                                width: battContent.width + 12
                                radius: 12
                                color: root.theme.bgSurface
                                Accessible.role: Accessible.StaticText
                                Accessible.name: "Battery: " + SystemInfo.batteryLevel

                                Row {
                                    id: battContent
                                    anchors.centerIn: parent
                                    spacing: 6

                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        visible: SystemInfo.batteryCharging
                                        text: "󱐋"
                                        color: root.theme.accentGreen
                                        font.pixelSize: 12
                                        font.family: "Hack Nerd Font"
                                    }
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: SystemInfo.batteryIcon
                                        color: root.theme.accentGreen
                                        font.pixelSize: 14
                                        font.family: "Hack Nerd Font"
                                    }
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: SystemInfo.batteryLevel
                                        color: root.theme.textPrimary
                                        font.pixelSize: 11
                                        font.family: "Hack Nerd Font"
                                    }
                                }
                            }
                        }
                    }

                    // System Tray
                    Rectangle {
                        implicitHeight: 24
                        implicitWidth: trayIcons.implicitWidth + 4
                        radius: 12
                        color: root.theme.bgSurface

                        RowLayout {
                            id: trayIcons
                            anchors.centerIn: parent
                            spacing: 2

                            Repeater {
                                model: SystemTray.items

                                MouseArea {
                                    id: trayDelegate
                                    required property SystemTrayItem modelData

                                    Accessible.role: Accessible.Button
                                    Accessible.name: modelData.tooltipTitle || modelData.title || "System tray item"

                                    Layout.preferredWidth: 24
                                    Layout.preferredHeight: 24

                                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                                    onClicked: mouse => {
                                        if (mouse.button === Qt.LeftButton) {
                                            modelData.activate();
                                        } else if (mouse.button === Qt.RightButton) {
                                            if (modelData.hasMenu) {
                                                menuAnchor.open();
                                            }
                                        } else if (mouse.button === Qt.MiddleButton) {
                                            modelData.secondaryActivate();
                                        }
                                    }

                                    IconImage {
                                        anchors.centerIn: parent
                                        source: trayDelegate.modelData.icon
                                        implicitSize: 16
                                    }

                                    QsMenuAnchor {
                                        id: menuAnchor
                                        menu: trayDelegate.modelData.menu

                                        anchor.window: trayDelegate.QsWindow.window
                                        anchor.adjustment: PopupAdjustment.Flip
                                        anchor.onAnchoring: {
                                            const window = trayDelegate.QsWindow.window;
                                            const widgetRect = window.contentItem.mapFromItem(trayDelegate, 0, trayDelegate.height, trayDelegate.width, trayDelegate.height);
                                            menuAnchor.anchor.rect = widgetRect;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
