import QtQuick

QtObject {
  readonly property color bgBase: "{{colors.surface_container_lowest.default.hex}}"
  readonly property color bgSurface: "{{colors.on_secondary_fixed.default.hex}}"
  readonly property color bgOverlay: "#88000000"
  readonly property color bgHover: "{{colors.surface_container.default.hex}}"
  readonly property color bgSelected: "{{colors.surface_container_high.default.hex}}"
  readonly property color bgBorder: "{{colors.outline_variant.default.hex}}"

  readonly property color textPrimary: "{{colors.on_surface.default.hex}}"
  readonly property color textSecondary: "{{colors.on_surface_variant.default.hex}}"
  readonly property color textMuted: "{{colors.outline.default.hex}}"

  readonly property color accentPrimary: "{{colors.primary.default.hex}}"
  readonly property color accentCyan: "{{colors.tertiary.default.hex}}"
  readonly property color accentGreen: "{{colors.secondary.default.hex}}"
  readonly property color accentOrange: "{{colors.error_container.default.hex}}"
  readonly property color accentRed: "{{colors.error.default.hex}}"

  readonly property color urgencyLow: textMuted
  readonly property color urgencyNormal: accentPrimary
  readonly property color urgencyCritical: accentRed
  readonly property color batteryGood: accentGreen
  readonly property color batteryWarning: accentOrange
  readonly property color batteryCritical: accentRed

}
