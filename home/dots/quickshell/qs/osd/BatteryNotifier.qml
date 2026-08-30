import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.UPower

Scope {
  id: root

  property bool notified20: false
  property bool notified10: false

  Process { id: notifyProc }

  Connections {
    target: UPower.displayDevice

    function onPercentageChanged() {
      let rawPct = UPower.displayDevice.percentage
      let pct = rawPct <= 1.0 ? Math.round(rawPct * 100) : Math.round(rawPct)

      // Reset when plugged in
      if (!UPower.onBattery) {
        root.notified20 = false
        root.notified10 = false
        return
      }

      // Critical warning (10%)
      if (pct <= 10 && !root.notified10) {
        root.notified10 = true
        notifyProc.command = ["notify-send", "-u", "critical", "Battery Critical", `Battery is at ${pct}%. Plug in charger now!`]
        notifyProc.running = true
      }
      // Low warning (20%)
      else if (pct <= 20 && !root.notified20) {
        root.notified20 = true
        notifyProc.command = ["notify-send", "-u", "normal", "Battery Low", `Battery is at ${pct}%.`]
        notifyProc.running = true
      }
    }
  }
}
