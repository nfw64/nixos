pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property list<string> wallpapers: []
    property string currentWallpaper: ""
    property string backend: "awww"

    Process {
        id: scanner
        command: ["sh", "-c", "find ~/nixos/assets/wallpapers/ ~/Pictures -maxdepth 2 -type f -regextype posix-extended -iregex '.*\\.(jpg|jpeg|png|webp|gif)$' 2>/dev/null"]
        running: false

        stdout: StdioCollector {
            waitForEnd: true
        }

        onRunningChanged: {
            if (!running) {
                const textData = stdout.text.trim();
                if (textData !== "") {
                    root.wallpapers = textData.split("\n");
                } else {
                    root.wallpapers = [];
                }
            }
        }
    }

    // Load saved wallpaper path
    FileView {
        id: configFile
        path: Quickshell.env("HOME") + "/.config/quickshell/wallpaper.conf"
        onTextChanged: {
            const saved = configFile.text().trim();
            if (saved !== "")
                root.currentWallpaper = saved;
        }
    }

    Component.onCompleted: {
        scanner.running = true;
    }

    function rescan() {
        wallpapers = [];
        scanner.running = true;
    }

    FileView {
        id: wallpaperConfigFile
    }

    function setWallpaper(path) {
        currentWallpaper = path;

        awwwProcess.command = ["setWal", path];
        awwwProcess.running = true;

        backendProcess.command = ["asyncmat", path];
        backendProcess.running = true;
    }

    Process {
        id: awwwProcess
        running: false
    }

    Process {
        id: backendProcess
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                if (this.text.trim() !== "") {
                    console.log("Backend Output: " + this.text.trim());
                }
            }
        }

        stderr: StdioCollector {
            onStreamFinished: {
                if (this.text.trim() !== "") {
                    console.error("Backend ERROR Log: " + this.text.trim());
                }
            }
        }

        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                Quickshell.reload(false);
            } else {
                console.error("Backend process abandoned. Exit Code: " + exitCode);
            }
        }
    }
}
