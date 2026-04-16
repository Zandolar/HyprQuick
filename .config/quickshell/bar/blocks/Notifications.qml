import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import Qt5Compat.GraphicalEffects
import "../"
import "root:/"

BarBlock {
    id: root

    property int count: 0
    property bool hasUnread: count > 0

    onClicked: function() {
        toggleSwaync.running = true
    }

    content: RowLayout {
        spacing: 4

        Text {
            // Bell icon — solid if unread, outline if clear
            text: root.hasUnread ? "󰂞" : ""
            font.pixelSize: 17
            font.family: "CaskaydiaCove Nerd Font Propo" // or whatever Nerd Font you use
            color: root.hasUnread ? Theme.get.notiAlert : Theme.get.barFontColor
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            width: 20
            leftPadding: 7
            topPadding: 2
            font {
                weight: Font.Bold
            }


            Behavior on color { ColorAnimation { duration: 300 } }
        }
            DropShadow {
                anchors.fill: parent
                horizontalOffset: 1
                verticalOffset: 3
                color: Theme.get.barFontShadow
                source: textcopy
            }
        Text {
            visible: root.hasUnread
            text: root.count
            font.pixelSize: 16
            color: Theme.get.notiColor
            topPadding: 3
            font {
                weight: Font.Bold
            }
        }
            DropShadow {
                anchors.fill: parent
                horizontalOffset: 1
                verticalOffset: 3
                color: Theme.get.barFontShadow
                source: textcopy
            }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: countProcess.running = true
    }

    Process {
        id: countProcess
        command: ["swaync-client", "-c"]
        stdout: SplitParser {
            onRead: data => root.count = parseInt(data.trim()) || 0
        }
    }

    Process {
        id: toggleSwaync
        command: ["swaync-client", "-t"]
    }
}
