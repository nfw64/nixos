import QtQuick

QtObject {
  readonly property color bgBase: "#0f0d13"
  readonly property color bgSurface: "#1c192b"
  readonly property color bgOverlay: "#88000000"
  readonly property color bgHover: "#201f25"
  readonly property color bgSelected: "#2b292f"
  readonly property color bgBorder: "#48454e"

  readonly property color textPrimary: "#e6e1e9"
  readonly property color textSecondary: "#c9c4d0"
  readonly property color textMuted: "#938f99"

  readonly property color accentPrimary: "#cabeff"
  readonly property color accentCyan: "#edb8cc"
  readonly property color accentGreen: "#c9c3dc"
  readonly property color accentOrange: "#93000a"
  readonly property color accentRed: "#ffb4ab"

  readonly property color urgencyLow: textMuted
  readonly property color urgencyNormal: accentPrimary
  readonly property color urgencyCritical: accentRed
  readonly property color batteryGood: accentGreen
  readonly property color batteryWarning: accentOrange
  readonly property color batteryCritical: accentRed

}
