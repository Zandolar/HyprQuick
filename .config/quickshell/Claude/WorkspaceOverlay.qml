import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import "./"

ShellRoot {

    Component.onCompleted: {
        Qt.callLater(() => {
            const ws = Hyprland.focusedWorkspace
            if (ws) {
                console.log("=== focusedWorkspace properties ===")
                for (var key in ws) {
                    try {
                        console.log(key, ":", ws[key])
                    } catch(e) {}
                }
            } else {
                console.log("focusedWorkspace still null after callLater")
            }
        })
    }

    Connections {
        target: Hyprland
        function onRawEvent(event) {
            console.log("RAW EVENT:", event.name, "|", event.data)
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
        visible: true

        Text {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 40
            text: {
                const ws = Hyprland.focusedWorkspace
                return ws ? "ws: " + JSON.stringify(ws) : "focusedWorkspace: null"
            }
            color: "red"
            font.pixelSize: 18
            z: 999
        }

        CalendarWidget {
            anchors.centerIn: parent
            isVisible: true
        }
    }
}
