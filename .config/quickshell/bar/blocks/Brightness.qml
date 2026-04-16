import QtQuick
import Quickshell
import Quickshell.Io
import "../"
import "root:/"

BarBlock {
  id: root

  property int brightnessPercent: 100

  property string icon: {
    if (brightnessPercent >= 75) return "󰃠";
    if (brightnessPercent >= 50) return "󰃟";
    if (brightnessPercent >= 25) return "󰃞";
    return "󰃝";
  }

  content: BarText { symbolText: `${root.icon} ${root.brightnessPercent}%` }

  Timer {
    interval: 50
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: brightnessProc.running = true
  }

  Process {
    id: brightnessProc
    command: ["bash", "-c", "brightnessctl -m | awk -F, '{print $4}' | tr -d '%'"]

    stdout: SplitParser {
      onRead: data => {
        var val = parseInt(data.trim());
        if (!isNaN(val)) root.brightnessPercent = val;
      }
    }
  }
}
