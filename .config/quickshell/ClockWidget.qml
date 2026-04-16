import Quickshell
import Quickshell.Wayland
import QtQuick
import Qt5Compat.GraphicalEffects
import "./"

// Plain Item — no ShellRoot/PanelWindow — so it can be embedded anywhere
Item {

    id: root

    property bool isVisible: true
    visible: isVisible

    // Size to whatever the Column needs
    implicitWidth: container.implicitWidth
    implicitHeight: container.implicitHeight

    FontLoader {
        id: font_anurati
        source: "/home/matt/.local/share/fonts/Anurati.otf"
    }

    FontLoader {
        id: font_poppins
        source: "/home/matt/.local/share/fonts/Poppins.ttf"
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Column {
        id: container
        anchors.centerIn: parent
        spacing: 4

        // ── Day of the week ───────────────────────
    Item {
        implicitWidth: clock_day_metrics.implicitWidth
        implicitHeight: clock_day_metrics.implicitHeight
        anchors.horizontalCenter: parent.horizontalCenter

    // Shadow
        Text {
            x: 4; y: 4
            text: clock_day_metrics.text
            font: clock_day_metrics.font
            color: Theme.get.dayShadowColor
        }

        // Hidden Text used for sizing + masking
        Text {
            id: clock_day_metrics
            text: Qt.formatDate(clock.date, "dddd").toUpperCase()
            font.family: font_anurati.name
            font.pixelSize: 105
            font.letterSpacing: 10
            visible: false
        }

        // Gradient rectangle, masked to the text shape
        Rectangle {
            width: clock_day_metrics.implicitWidth
            height: clock_day_metrics.implicitHeight

            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.get.dayColorTop }  // top
                GradientStop { position: 0.5; color: Theme.get.dayColorMid }  // mid
                GradientStop { position: 1.0; color: Theme.get.dayColorBot }  // bottom
            }

            layer.enabled: true
            layer.effect: OpacityMask {
                maskSource: Text {
                    width: clock_day_metrics.implicitWidth
                    height: clock_day_metrics.implicitHeight
                    text: clock_day_metrics.text
                    font: clock_day_metrics.font
                }
            }
        }
    }

        // ── Date ──────────────────────────────────
        Item {
            implicitWidth: clock_date.implicitWidth
            implicitHeight: clock_date.implicitHeight
            anchors.horizontalCenter: parent.horizontalCenter

            Text {
                x: 3; y: 3
                text: clock_date.text
                font: clock_date.font
                color: Theme.get.dateShadowColor
            }
            Text {
                id: clock_date
                text: Qt.formatDate(clock.date, "dd MMM    yyyy").toUpperCase()
                font.family: font_poppins.name
                font.weight: Font.Bold
                font.pixelSize: 25
                color: Theme.get.dateFontColor
            }
        }
    }
}