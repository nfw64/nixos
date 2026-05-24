import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Variants {
    id: root

    property color backgroundColor: Qt.alpha(theme.bgBase, 0.8)
    property color buttonColor: theme.bgHover
    property color buttonHoverColor: theme.bgSurfaceDef
    property bool isPanelOpen: false
    default property list<Button> buttons

    model: Quickshell.screens
    PanelWindow {
        id: mainPanel
        visible: mainRectangle.opacity > 0

        property var modelData
        screen: modelData

        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        color: "transparent"
        contentItem {
            focus: true
            Keys.onPressed: event => {
                // 1. Handle explicit Escape sequence
                if (event.key === Qt.Key_Escape) {
                    root.isPanelOpen = false;
                    event.accepted = true;
                    return;
                }

                // 2. Loop through buttons list to match the keybind
                for (var i = 0; i < root.buttons.length; i++) {
                    var btn = root.buttons[i];
                    if (btn.keybind && event.key === btn.keybind) {
                        root.isPanelOpen = false;
                        btn.exec();                // Execute backend process
                        event.accepted = true;
                        return;
                    }
                }

                // 3. Passthrough unhandled system keys cleanly
                event.accepted = false;
            }
        }

        anchors {
            top: true
            left: true
            bottom: true
            right: true
        }

        Rectangle {
            id: mainRectangle
            color: backgroundColor
            anchors.fill: parent

            visible: opacity > 0
            opacity: root.isPanelOpen ? 1.0 : 0.0

            Behavior on opacity {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: root.isPanelOpen = false

                GridLayout {
                    anchors.centerIn: parent

                    width: parent.width / 2
                    height: parent.height / 2

                    columns: 3
                    columnSpacing: 30
                    rowSpacing: 30

                    Repeater {
                        model: buttons
                        delegate: Rectangle {
                            required property Button modelData

                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            radius: 100

                            color: ma.containsMouse ? buttonHoverColor : buttonColor

                            Behavior on color {
                                ColorAnimation {
                                    id: fadeOutAnimation
                                    duration: 250
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            MouseArea {
                                id: ma
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    root.isPanelOpen = false;
                                    modelData.exec();
                                }
                            }

                            Image {
                                id: icon
                                anchors.centerIn: parent
                                source: `icons/${modelData.icon}.png`
                                width: parent.width / 4
                                height: parent.width / 4

                                // This prevents squishing/stretching
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                    }
                }
            }
        }
    }
}
