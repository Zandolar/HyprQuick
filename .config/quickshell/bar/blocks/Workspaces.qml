import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import "../utils" as Utils
import "root:/"

RowLayout {
    property HyprlandMonitor monitor: Hyprland.monitorFor(screen)

    Rectangle {
        id: workspaceBackground
        Layout.preferredWidth: Math.max(50, Utils.HyprlandUtils.maxWorkspace * 33) + 16
        Layout.preferredHeight: 36
        Layout.leftMargin: 4
        radius: 6
        color: Theme.get.barBgColor

        Rectangle {
            id: workspaceBar
            anchors.centerIn: parent
            width: Math.max(50, Utils.HyprlandUtils.maxWorkspace * 33)
            height: 28
            radius: 7
            color: Theme.get.wsBgColor

            Row {
                anchors.centerIn: parent
                spacing: 4

                Repeater {
                    model: Utils.HyprlandUtils.maxWorkspace || 1

                    Item {
                        required property int index
                        property bool focused: Hyprland.focusedMonitor?.activeWorkspace?.id === (index + 1)
                        property var ws: Hyprland.workspaces.values.find(w => w.id === (index + 1))
                        property bool occupied: ws !== undefined

                        width: workspaceText.width + 10
                        height: workspaceText.height + 6

                        Rectangle {
                            anchors.fill: parent
                            radius: 4
                            color: focused ? Theme.get.wsActiveColor : "transparent"
                        }

                        Text {
                            id: workspaceText
                            anchors.centerIn: parent
                            text: ["", "", "", "", "", "", "", "", "", ""][index] || (index + 1).toString()
                            color: focused ? Theme.get.wsActiveTextColor : (occupied ? Theme.get.wsOccupiedTextColor : Theme.get.wsEmptyTextColor)
                            font.pixelSize: 18
                            font.bold: focused
                        }

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: Utils.HyprlandUtils.switchWorkspace(index + 1)
                        }
                    }
                }
            }
        }
    }
}
