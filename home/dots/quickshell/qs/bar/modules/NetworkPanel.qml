import QtQuick 6.10
import QtQuick.Layouts 6.10
import QtQuick.Controls 6.10 as QQC
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import "services"

PopupWindow {
  id: popupWindow
  property var theme: DefaultTheme {}
  readonly property var network: NetworkService
  property bool isPanelOpen: false
  signal requestClose()
  readonly property var sortedNetworks: [...network.networks].sort((a, b) => {
      if (a.active !== b.active)
      return b.active - a.active;
      return b.strength - a.strength;
  })

  color: "transparent"

  // Solid colors like Control Center
  readonly property color cSurface: theme.bgSurface
  readonly property color cSurfaceContainer: Qt.lighter(theme.bgSurface, 1.15)
  readonly property color cPrimary: theme.accentPrimary
  readonly property color cText: theme.textPrimary
  readonly property color cSubText: Qt.rgba(cText.r, cText.g, cText.b, 0.6)
  readonly property color cBorder: Qt.rgba(cText.r, cText.g, cText.b, 0.08)
  readonly property color cHover: Qt.rgba(cText.r, cText.g, cText.b, 0.06)

  // Set your menu boundaries
  implicitWidth: 350
  implicitHeight: 370

  visible: isPanelOpen || popupPanel.opacity > 0

  FocusScope {
    id: popupPanel
    opacity: 0
    y: 0

    states: [
    State {
      name: "open"
      when: isPanelOpen
      PropertyChanges {
        target: popupPanel
        opacity: 1
        y: 0
      }
    },
    State {
      name: "closed"
      when: !isPanelOpen
      PropertyChanges {
        target: popupPanel
        opacity: 0
        y: -100
      }
    }
    ]

    transitions: [
    Transition {
      from: "closed"; to: "open"
      ParallelAnimation {
        NumberAnimation {
          target: popupPanel
          property: "opacity"
          duration: 150
        }
        NumberAnimation {
          target: popupPanel
          property: "y"
          duration: 300
          easing.type: Easing.OutCubic
        }
      }
    },
    Transition {
      from: "open"; to: "closed"
      ParallelAnimation {
        NumberAnimation {
          target: popupPanel
          property: "opacity"
          duration: 150
        }
        NumberAnimation {
          target: popupPanel
          property: "y"
          duration: 300
          easing.type: Easing.InOutCubic
        }
      }
    }
    ]

    focus: isPanelOpen // Requests keyboard focus when the panel opens

    // Settings launcher
    Process {
      id: settingsProcess
      command: ["nm-connection-editor"]
      onStarted: popupWindow.requestClose()
    }

    implicitWidth: 340
    implicitHeight: contentColumn.implicitHeight + 29
    property bool mouseHasEntered: false
    property bool mouseInside: hoverHandler.hovered

    HoverHandler {
      id: hoverHandler
      onHoveredChanged: {
        if (hovered) {
          popupPanel.mouseHasEntered = true
          closeTimer.stop()
        } else if (popupPanel.mouseHasEntered && popupWindow.isPanelOpen) {
          closeTimer.restart()
        }
      }
    }

    Timer {
      id: closeTimer
      interval: 400
      onTriggered: {
        if (!popupPanel.mouseInside && popupPanel.mouseHasEntered && isPanelOpen) {
          popupWindow.requestClose()
        }
      }
    }

    Keys.onEscapePressed: {
      if (!passwordDialog.isOpen)
      popupWindow.requestClose()
    }

    // Background with shadow
    ClippingRectangle {
      id: mainClip
      anchors.fill: parent
      color: "transparent"
      radius: 16
      clip: true
      Rectangle {
        id: backgroundRect
        anchors.fill: parent
        color: cSurface
        radius: 16
        border.color: cBorder
        border.width: 1

        layer.enabled: true
        layer.effect: MultiEffect {
          shadowEnabled: true
          shadowColor: Qt.rgba(0, 0, 0, 0.35)
          shadowBlur: 1.0
          shadowVerticalOffset: 6
        }
      }
      ColumnLayout {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Header
        RowLayout {
          Layout.fillWidth: true
          spacing: 12

          Rectangle {
            width: 36
            height: 36
            radius: 12
            color: Qt.rgba(cPrimary.r, cPrimary.g, cPrimary.b, 0.15)

            Text {
              anchors.centerIn: parent
              text: "󰖩"
              font.family: "Material Design Icons"
              font.pixelSize: 18
              color: cPrimary
            }
          }

          ColumnLayout {
            Layout.fillWidth: true
            spacing: 2

            Text {
              text: "WiFi Networks"
              font.family: "Inter"
              font.pixelSize: 15
              font.weight: Font.Bold
              color: cText
            }

            Text {
              text: network.active ? network.active.ssid : "Not connected"
              font.family: "Inter"
              font.pixelSize: 11
              color: cSubText
            }
          }

          // Toggle
          Rectangle {
            width: 44
            height: 24
            radius: 12
            color: network.wifiEnabled ? cPrimary : Qt.rgba(cText.r, cText.g, cText.b, 0.15)

            Behavior on color {
              ColorAnimation {
                duration: 150
              }
            }

            Rectangle {
              width: 18
              height: 18
              radius: 9
              anchors.verticalCenter: parent.verticalCenter
              x: network.wifiEnabled ? parent.width - width - 3 : 3
              color: "#ffffff"

              Behavior on x {
                NumberAnimation {
                  duration: 150
                  easing.type: Easing.OutCubic
                }
              }
            }

            MouseArea {
              anchors.fill: parent
              cursorShape: Qt.PointingHandCursor
              onClicked: network.toggleWifi()
            }
          }
        }

        // Scan button
        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 36
          radius: 10
          color: scanArea.containsMouse ? cHover : cSurfaceContainer

          Behavior on color {
            ColorAnimation {
              duration: 100
            }
          }

          RowLayout {
            anchors.centerIn: parent
            spacing: 8

            Text {
              text: network.scanning ? "󰑐" : "󰑓"
              font.family: "Material Design Icons"
              font.pixelSize: 16
              color: network.scanning ? cPrimary : cText

              RotationAnimation on rotation {
                running: network.scanning
                from: 0
                to: 360
                duration: 1000
                loops: Animation.Infinite
              }
            }

            Text {
              text: network.scanning ? "Scanning..." : "Scan networks"
              font.family: "Inter"
              font.pixelSize: 12
              font.weight: Font.Medium
              color: cText
            }
          }

          MouseArea {
            id: scanArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            enabled: network.wifiEnabled
            onClicked: network.rescanWifi()
          }
        }

        // Network List
        Rectangle {
          id: networkRec
          Layout.fillWidth: true
          Layout.preferredHeight: sortedNetworks.length === 0 ? 90 : Math.min(networkList.contentHeight + 8, 196)
          radius: 12
          color: sortedNetworks.length === 0 ? "transparent" : cSurfaceContainer
          clip: true
          z: 1
          Behavior on Layout.preferredHeight {
            NumberAnimation { duration: 150; easing.type: Easing.OutCubic }
          }

          ListView {
            id: networkList
            anchors.fill: parent
            visible: sortedNetworks.length > 0
            anchors.margins: 4
            spacing: 2
            model: sortedNetworks
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            delegate: Rectangle {
              id: networkItem
              width: networkList.width
              height: 45
              radius: 10
              color: itemArea.containsMouse ? cHover : "transparent"

              required property var modelData
              property bool isActive: modelData.active

              Behavior on color {
                ColorAnimation {
                  duration: 80
                }
              }

              RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 12
                spacing: 10

                // Signal
                Text {
                  text: {
                    const s = networkItem.modelData.strength;
                    if (s >= 75)
                    return "󰤨";
                    if (s >= 50)
                    return "󰤥";
                    if (s >= 25)
                    return "󰤢";
                    return "󰤟";
                  }
                  font.family: "Material Design Icons"
                  font.pixelSize: 18
                  color: isActive ? cPrimary : cText
                }

                ColumnLayout {
                  Layout.fillWidth: true
                  spacing: 2

                  RowLayout {
                    spacing: 4
                    Text {
                      text: networkItem.modelData.ssid
                      font.family: "Inter"
                      font.pixelSize: 12
                      font.weight: Font.Medium
                      color: cText
                      elide: Text.ElideRight
                      Layout.fillWidth: true
                    }
                    Text {
                      visible: networkItem.modelData.isSecure
                      text: "󰌾"
                      font.family: "Material Design Icons"
                      font.pixelSize: 10
                      color: cSubText
                    }
                  }

                  Text {
                    text: isActive ? "Connected" : `${networkItem.modelData.strength}%`
                    font.family: "Inter"
                    font.pixelSize: 10
                    color: isActive ? cPrimary : cSubText
                  }
                }

                // Action
                Rectangle {
                  width: 28
                  height: 28
                  radius: 14
                  color: actionArea.containsMouse ? Qt.rgba(cPrimary.r, cPrimary.g, cPrimary.b, 0.15) : "transparent"
                  border.width: 1
                  border.color: isActive ? cPrimary : Qt.rgba(cText.r, cText.g, cText.b, 0.15)

                  Text {
                    anchors.centerIn: parent
                    text: isActive ? "󰌊" : "󰌘"
                    font.family: "Material Design Icons"
                    font.pixelSize: 14
                    color: isActive ? cPrimary : cSubText
                  }

                  MouseArea {
                    id: actionArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                      if (isActive) {
                        network.disconnectFromNetwork();
                      } else {
                        const isSaved = network.savedNetworks.includes(networkItem.modelData.ssid);
                        if (isSaved) {
                          network.connectToNetwork(networkItem.modelData.ssid, "");
                        } else if (networkItem.modelData.isSecure) {
                          passwordDialog.networkSSID = networkItem.modelData.ssid;
                          passwordDialog.open();
                        } else {
                          network.connectToNetwork(networkItem.modelData.ssid, "");
                        }
                      }
                    }
                  }
                }
              }

              MouseArea {
                id: itemArea
                anchors.fill: parent
                hoverEnabled: true
                z: -1
              }
            }
          }

          // Empty state
          ColumnLayout {
            anchors.centerIn: parent
            visible: sortedNetworks.length === 0
            spacing: 6

            Text {
              Layout.alignment: Qt.AlignHCenter
              text: "󰖪"
              font.family: "Material Design Icons"
              font.pixelSize: 32
              color: Qt.rgba(cText.r, cText.g, cText.b, 0.2)
            }

            Text {
              Layout.alignment: Qt.AlignHCenter
              text: network.wifiEnabled ? "No networks found" : "WiFi disabled"
              font.family: "Inter"
              font.pixelSize: 12
              color: cSubText
            }
          }
        }

        // Settings button
        Rectangle {
          Layout.fillWidth: true
          Layout.preferredHeight: 36
          radius: 10
          color: settingsArea.containsMouse ? cHover : "transparent"
          z: 3

          RowLayout {
            anchors.centerIn: parent
            spacing: 6

            Text {
              text: "󰒓"
              font.family: "Material Design Icons"
              font.pixelSize: 14
              color: cSubText
            }

            Text {
              text: "Network Settings"
              font.family: "Inter"
              font.pixelSize: 12
              color: cSubText
            }
          }

          MouseArea {
            id: settingsArea
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: settingsProcess.running = true
          }
        }
      }

      // Password Dialog
      Item {
        id: passwordDialog
        anchors.fill: parent
        visible: opacity > 0
        z: 100

        property string networkSSID: ""
        property bool isOpen: false

        opacity: 0

        function open() {
          isOpen = true;
          passwordInput.forceActiveFocus();
        }
        function close() {
          isOpen = false;
          passwordInput.text = "";
        }

        states: State {
          name: "open"
          when: passwordDialog.isOpen
          PropertyChanges {
            target: passwordDialog
            opacity: 1
          }
          PropertyChanges {
            target: dialogCard
            scale: 1.0
          }
        }

        transitions: [
        Transition {
          to: "open"
          ParallelAnimation {
            NumberAnimation {
              target: passwordDialog
              property: "opacity"
              duration: 150
            }
            NumberAnimation {
              target: dialogCard
              property: "scale"
              duration: 200
              easing.type: Easing.OutBack
            }
          }
        },
        Transition {
          from: "open"
          ParallelAnimation {
            NumberAnimation {
              target: passwordDialog
              property: "opacity"
              duration: 100
            }
            NumberAnimation {
              target: dialogCard
              property: "scale"
              to: 0.9
              duration: 100
            }
          }
        }
        ]

        Rectangle {
          anchors.fill: parent
          color: Qt.rgba(0, 0, 0, 0.5)
          radius: 16
          MouseArea {
            anchors.fill: parent
            onClicked: passwordDialog.close()
          }
        }

        Rectangle {
          id: dialogCard
          anchors.centerIn: parent
          width: 300
          height: dialogColumn.implicitHeight + 40
          radius: 16
          color: cSurface
          scale: 0.9
          border.color: cBorder

          ColumnLayout {
            id: dialogColumn
            anchors.fill: parent
            anchors.margins: 20
            spacing: 14

            Text {
              text: "Enter Password"
              font.family: "Inter"
              font.pixelSize: 14
              font.weight: Font.Bold
              color: cText
            }

            Text {
              text: passwordDialog.networkSSID
              font.family: "Inter"
              font.pixelSize: 11
              color: cSubText
            }

            Rectangle {
              Layout.fillWidth: true
              Layout.preferredHeight: 40
              radius: 10
              color: cSurfaceContainer
              border.color: passwordInput.activeFocus ? cPrimary : "transparent"
              border.width: 1

              QQC.TextField {
                id: passwordInput
                anchors.fill: parent
                anchors.margins: 10
                placeholderText: "Password"
                echoMode: QQC.TextField.Password
                color: cText
                background: Item {}
                font.family: "Inter"
                font.pixelSize: 13

                onAccepted: {
                  if (text.length > 0) {
                    network.connectToNetwork(passwordDialog.networkSSID, text);
                    passwordDialog.close();
                  }
                }
              }
            }

            RowLayout {
              Layout.fillWidth: true
              spacing: 10

              Item {
                Layout.fillWidth: true
              }

              Rectangle {
                width: 70
                height: 32
                radius: 16
                color: cancelBtn.containsMouse ? cHover : "transparent"
                border.width: 1
                border.color: Qt.rgba(cText.r, cText.g, cText.b, 0.15)

                Text {
                  anchors.centerIn: parent
                  text: "Cancel"
                  font.family: "Inter"
                  font.pixelSize: 12
                  color: cText
                }

                MouseArea {
                  id: cancelBtn
                  anchors.fill: parent
                  hoverEnabled: true
                  cursorShape: Qt.PointingHandCursor
                  onClicked: passwordDialog.close()
                }
              }

              Rectangle {
                width: 80
                height: 32
                radius: 16
                color: passwordInput.text.length > 0 ? cPrimary : Qt.rgba(cPrimary.r, cPrimary.g, cPrimary.b, 0.4)

                Text {
                  anchors.centerIn: parent
                  text: "Connect"
                  font.family: "Inter"
                  font.pixelSize: 12
                  font.weight: Font.Medium
                  color: "#ffffff"
                }

                MouseArea {
                  anchors.fill: parent
                  enabled: passwordInput.text.length > 0
                  cursorShape: Qt.PointingHandCursor
                  onClicked: {
                    network.connectToNetwork(passwordDialog.networkSSID, passwordInput.text);
                    passwordDialog.close();
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
