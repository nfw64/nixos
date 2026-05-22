pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    property string cpuUsage: "0%"
    property string memoryUsage: "0%"
    property string networkInfo: "Disconnected"
    property string networkType: "disconnected"
    property int batteryLevelRaw: 0
    property string batteryLevel: "0%"
    property string batteryIcon: "󰂎"

    property bool batteryCharging: false
    property string temperature: "0°C"

    property var prevCpu: ({
            total: 0,
            idle: 0
        })

    // CPU Usage
    FileView {
        id: procStat
        path: "/proc/stat"
        onTextChanged: {
            let fileContent = procStat.text();
            if (!fileContent)
                return;

            let firstLine = fileContent.substring(0, fileContent.indexOf('\n'));
            let parts = firstLine.trim().split(/\s+/);

            let user = parseInt(parts[1]) || 0;
            let nice = parseInt(parts[2]) || 0;
            let system = parseInt(parts[3]) || 0;
            let idle = parseInt(parts[4]) || 0;
            let iowait = parseInt(parts[5]) || 0;
            let irq = parseInt(parts[6]) || 0;
            let softirq = parseInt(parts[7]) || 0;

            let currentIdle = idle + iowait;
            let currentTotal = user + nice + system + currentIdle + irq + softirq;

            let totalDelta = currentTotal - root.prevCpu.total;
            let idleDelta = currentIdle - root.prevCpu.idle;

            if (totalDelta > 0) {
                root.cpuUsage = Math.round(((totalDelta - idleDelta) / totalDelta) * 100) + "%";
            }

            root.prevCpu.total = currentTotal;
            root.prevCpu.idle = currentIdle;
        }
    }

    // Memory Usage
    FileView {
        id: procMem
        path: "/proc/meminfo"
        onTextChanged: {
            let fileContent = procMem.text();
            if (!fileContent)
                return;

            let memTotal = 0;
            let memAvailable = 0;
            let lines = fileContent.split('\n');

            for (let i = 0; i < lines.length; i++) {
                if (lines[i].startsWith("MemTotal:")) {
                    memTotal = parseInt(lines[i].replace(/[^0-9]/g, ''));
                } else if (lines[i].startsWith("MemAvailable:")) {
                    memAvailable = parseInt(lines[i].replace(/[^0-9]/g, ''));
                }
                if (memTotal && memAvailable)
                    break;
            }

            if (memTotal > 0) {
                let memUsed = memTotal - memAvailable;
                root.memoryUsage = ((memUsed / memTotal) * 100).toFixed(1) + "%";
            }
        }
    }

    // Network Info (ethernet takes priority over wifi)

    Process {
        id: netProc
        command: ["nmcli", "-t", "-f", "TYPE,STATE,CONNECTION", "device"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                let rawText = this.text;

                if (!rawText) {
                    root.networkType = "disconnected";
                    root.networkInfo = "Disconnected";
                    return;
                }

                let lines = rawText.trim().split("\n");
                let wifiSSID = "";
                let hasEthernet = false;

                for (let i = 0; i < lines.length; i++) {
                    let parts = lines[i].split(":");
                    let type = parts[0];
                    let state = parts[1];
                    let connection = parts[2];

                    if (type === "ethernet" && state === "connected") {
                        hasEthernet = true;
                        break;
                    } else if (type === "wifi" && state === "connected") {
                        wifiSSID = connection;
                    }
                }

                if (hasEthernet) {
                    root.networkType = "ethernet";
                    root.networkInfo = "Ethernet";
                } else if (wifiSSID) {
                    root.networkType = "wifi";
                    root.networkInfo = wifiSSID;
                } else {
                    root.networkType = "disconnected";
                    root.networkInfo = "Disconnected";
                }
            }
        }
    }

    Process {
        id: netProcd
        command: ["sh", "-c", "eth=$(nmcli -t -f type,state dev 2>/dev/null | grep '^ethernet:connected'); if [ -n \"$eth\" ]; then echo 'ethernet:Ethernet'; else wifi=$(nmcli -t -f active,ssid dev wifi 2>/dev/null | grep '^yes' | cut -d: -f2); if [ -n \"$wifi\" ]; then echo \"wifi:$wifi\"; else echo 'disconnected:'; fi; fi"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                const result = text.trim();
                const colonIdx = result.indexOf(':');
                const type = result.substring(0, colonIdx);
                const info = result.substring(colonIdx + 1);
                root.networkType = type;
                console.log(type);
                root.networkInfo = "lol" || "Disconnected";
            }
        }
    }

    // Battery
    // 4. Battery Level & Status (0 Processes)
    // Replace 'BAT0' below with 'BAT1' if your laptop uses a different enumeration
    FileView {
        id: batCapacity
        path: "/sys/class/power_supply/BAT1/capacity"
        onTextChanged: {
            let content = batCapacity.text();
            if (!content)
                return;
            let level = parseInt(content.trim()) || 0;
            root.batteryLevelRaw = level;
            root.batteryLevel = level + "%";

            // Map icons sequentially without massive if-else branching loops
            let icons = ["󰁺", "󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"];
            let idx = Math.floor(level / 10);
            root.batteryIcon = icons[Math.min(idx, 10)];
        }
    }

    FileView {
        id: batStatus
        path: "/sys/class/power_supply/BAT1/status"
        onTextChanged: {
            let content = batStatus.text();
            if (!content)
                return;
            root.batteryCharging = (content.trim() === "Charging");
        }
    }

    // Temperature
    FileView {
        id: thermalZone
        // Note: zone0 or zone1 usually represents the main CPU package/tctl.
        // Adjust index if yours maps differently, or use /sys/class/hwmon
        path: "/sys/class/thermal/thermal_zone0/temp"
        onTextChanged: {
            let content = thermalZone.text();
            if (!content)
                return;
            let millidegrees = parseInt(content.trim());
            if (!isNaN(millidegrees)) {
                root.temperature = Math.round(millidegrees / 1000) + "°C";
            }
        }
    }

    // Update timer
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            procStat.reload();
            procMem.reload();
            thermalZone.reload();
            batCapacity.reload();
            batStatus.reload();
            netProc.running = true;
        }
    }
}
