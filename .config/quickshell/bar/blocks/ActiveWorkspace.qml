import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Hyprland
import "~/.config/quickshell"
import "../"
import "root:/"

Rectangle {
  implicitWidth: label.implicitWidth + 16
  implicitHeight: label.implicitHeight + 8

  color: Theme.get.barBgColor
  radius: 6

  property int chopLength
  property string activeWindowTitle
  property alias text: label.text
  property color textColor: Theme.get.barFontColor

  BarText {
    id: label
    pointSize: 13
    anchors.centerIn: parent
    color: textColor
    font.family: "URW Gothic"
    // text: {
    //   var str = activeWindowTitle
    //   return str.length > chopLength ? str.slice(0, chopLength) + '...' : str;
    // }
  }

  Process {
    id: titleProc
    command: ["sh", "-c", "hyprctl activewindow | grep title: | sed 's/^[^:]*: //'"]
    running: true

    stdout: SplitParser {
      onRead: data => activeWindowTitle = data
    }
  }

  Component.onCompleted: {
    Hyprland.rawEvent.connect(hyprEvent)
  }

  function hyprEvent(e) {
    titleProc.running = true
  }
}