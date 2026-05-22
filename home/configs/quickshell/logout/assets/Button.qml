import QtQuick
import Quickshell.Io

QtObject {
    id: button
    required property string command
    required property string text
    required property string icon
    property var keybind: null

    // Comment out the real process while you are testing

    default property list<QtObject> internalObjects: [
        Process {
            id: myProcess
            command: ["sh", "-c", button.command]
            stdout: StdioCollector {
                onStreamFinished: console.log("Command Output: " + text)
            }
            stderr: StdioCollector {
                onStreamFinished: console.critical("Command Error: " + text)
            }
        }
    ]
    readonly property var process: myProcess

    function exec() {
        process.startDetached();
        Qt.quit();
    }
}
