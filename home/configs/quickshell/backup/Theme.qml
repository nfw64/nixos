import QtQuick

QtObject {
  readonly property color bgBase: "#0a0f11"
  readonly property color bgSurface: "#071e26"
  readonly property color bgOverlay: "#88000000"
  readonly property color bgHover: "#1b2023"
  readonly property color bgSelected: "#252b2d"
  readonly property color bgBorder: "#40484c"

  readonly property color textPrimary: "#dee3e6"
  readonly property color textSecondary: "#c0c8cc"
  readonly property color textMuted: "#8a9296"

  readonly property color accentPrimary: "#8ad0ee"
  readonly property color accentCyan: "#c5c3ea"
  readonly property color accentGreen: "#b4cad5"
  readonly property color accentOrange: "#93000a"
  readonly property color accentRed: "#ffb4ab"

  readonly property color urgencyLow: textMuted
  readonly property color urgencyNormal: accentPrimary
  readonly property color urgencyCritical: accentRed
  readonly property color batteryGood: accentGreen
  readonly property color batteryWarning: accentOrange
  readonly property color batteryCritical: accentRed

}
