import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "./"

ShellRoot {

    // Log ALL events so we can see what signal name to use
    Connections {
        target: Hyprland
        function onRawEvent(event) {
            console.log("RAW EVENT:", event.name, event.data)
        }
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

        // FORCED visible so we can always see the debug label
        visible: true

        // Shows live state regardless of window count
        Text {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 40
            text: {
                const ws = Hyprland.focusedWorkspace
                return ws
                    ? "focusedWorkspace OK | windowCount: " + ws.windowCount
                    : "focusedWorkspace: null"
            }
            color: "red"
            font.pixelSize: 24
            z: 999
        }

        CalendarWidget {
            anchors.centerIn: parent
            isVisible: true
        }
    }
}
