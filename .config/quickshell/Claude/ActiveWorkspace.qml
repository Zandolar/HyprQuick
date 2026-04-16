import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Hyprland
import "../"

Rectangle {
  implicitWidth: label.implicitWidth + 16
  implicitHeight: label.implicitHeight + 8

  color: Theme.get.activewsBgColor ?? "transparent"
  radius: 6

  property int chopLength
  property string activeWindowTitle

  BarText {
    id: label
    anchors.centerIn: parent

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
