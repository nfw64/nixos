import QtQuick

QtObject {
  readonly property color bgBase: "#130d07"
  readonly property color bgSurface: "#281805"
  readonly property color bgOverlay: "#88000000"
  readonly property color bgHover: "#251e17"
  readonly property color bgSelected: "#302921"
  readonly property color bgBorder: "#50453a"

  readonly property color textPrimary: "#eee0d5"
  readonly property color textSecondary: "#d4c4b5"
  readonly property color textMuted: "#9d8e81"

  readonly property color accentPrimary: "#f9ba72"
  readonly property color accentCyan: "#bdcd9d"
  readonly property color accentGreen: "#e0c1a3"
  readonly property color accentOrange: "#93000a"
  readonly property color accentRed: "#ffb4ab"

  readonly property color urgencyLow: textMuted
  readonly property color urgencyNormal: accentPrimary
  readonly property color urgencyCritical: accentRed
  readonly property color batteryGood: accentGreen
  readonly property color batteryWarning: accentOrange
  readonly property color batteryCritical: accentRed

}
