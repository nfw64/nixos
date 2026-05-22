import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Variants {
    id: root
    property color backgroundColor: "#e60c0c0c"
    property color buttonColor: "#1e1e1e"
    property color buttonHoverColor: "#3700b3"
    default property list<Button> buttons

    model: Quickshell.screens
    PanelWindow {
        id: mainPanel

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
                    mainRectangle.opacity = 0;
                    event.accepted = true;
                    return;
                }

                // 2. Loop through buttons list to match the keybind
                for (var i = 0; i < root.buttons.length; i++) {
                    var btn = root.buttons[i];
                    if (btn.keybind && event.key === btn.keybind) {
                        mainRectangle.opacity = 0; // Trigger fade out sequence
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

            opacity: 0
            Behavior on opacity {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.InOutQuad
                    onFinished: {
                        if (panel.opacity === 0) {
                            Qt.quit();
                        }
                    }
                }
            }

            onOpacityChanged: {
                if (opacity === 0) {
                    Qt.quit();
                }
            }

            // 3. Trigger the fade-in once the component is fully loaded
            Component.onCompleted: {
                mainRectangle.opacity = 1;
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.quit()

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
                                onClicked: modelData.exec()
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
