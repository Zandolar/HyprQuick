import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import "root:/"

Text {
  property string mainFont: "Orbitron"
  property string symbolFont: "Symbols Nerd Font Mono"
  property int pointSize: 13
  property int symbolSize: pointSize * 1.5
  property string symbolText
  property bool dim
  text: wrapSymbols(symbolText)
  anchors.centerIn: parent
  property color textColor: Theme.get.barFontColor
  color: dim ? '#ad949494' : textColor
  textFormat: Text.RichText
  font {
    family: mainFont
    pointSize: pointSize
    weight: Font.Bold
  }

  Text {
    visible: false
    id: textcopy
    text: parent.text
    textFormat: parent.textFormat
    color: parent.color
    font: parent.font
  }

  DropShadow {
    anchors.fill: parent
    horizontalOffset: 1
    verticalOffset: 3
    color: Theme.get.barFontShadow
    source: textcopy
  }

  function wrapSymbols(text) {
    if (!text)
      return ""

    const isSymbol = (codePoint) =>
        (codePoint >= 0xE000   && codePoint <= 0xF8FF) // Private Use Area
     || (codePoint >= 0xF0000  && codePoint <= 0xFFFFF) // Supplementary Private Use Area-A
     || (codePoint >= 0x100000 && codePoint <= 0x10FFFF); // Supplementary Private Use Area-B

    return text.replace(/./gu, (c) => isSymbol(c.codePointAt(0))
      ? `<span style='font-family: ${symbolFont}; letter-spacing: 5px; font-size: ${symbolSize}px'>${c}</span>`
      // ? c
      : c);
  }
}

