import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import "./"

ShellRoot {

    property int windowCount: 0

    // Poll active workspace window count via hyprctl
    Process {
        id: hyprctlProcess
        command: ["sh", "-c", "hyprctl activeworkspace -j | python3 -c \"import sys,json; d=json.load(sys.stdin); print(d['windows'])\""]
        running: false

        stdout: SplitParser {
            onRead: data => {
                const n = parseInt(data.trim())
                if (!isNaN(n)) {
                    windowCount = n
                    console.log("windowCount:", n)
                }
            }
        }
    }

    // Re-query on relevant Hyprland events
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            const tracked = ["workspace", "openwindow", "closewindow", "movewindow", "focusedmon"]
            if (tracked.includes(event.name)) {
                hyprctlProcess.running = true
            }
        }
    }

    // Initial query once shell is ready
    Component.onCompleted: {
        Qt.callLater(() => hyprctlProcess.running = true)
    }

    PanelWindow {
        id: overlayWindow

        WlrLayershell.layer: WlrLayer.Bottom
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

        anchors {
            top: true; bottom: true
            left: true; right: true
        }

        color: "transparent"
        visible: windowCount === 0

        CalendarWidget {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 140   // enough to clear your bar height + a little breathing room
            anchors.rightMargin: 16
            isVisible: overlayWindow.visible 
        }

        PlexampWidget {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 140
            anchors.leftMargin: 16
            isVisible: overlayWindow.visible
        }

        ClockWidget {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 25
            isVisible: overlayWindow.visible
        }
    }
}
