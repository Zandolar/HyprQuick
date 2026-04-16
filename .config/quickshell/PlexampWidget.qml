import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Io
import Qt5Compat.GraphicalEffects
import "root:/"

Rectangle {

    FontLoader { source: "/home/matt/.local/share/fonts/Rockstar-ExtraBold.otf" }
    FontLoader { source: "/home/matt/.local/share/fonts/TR Impact.TTF" }
    FontLoader { source: "/home/matt/.local/share/fonts/minion_plus_minion_equals_chaos_font.ttf" } 

    id: root

    width: 540
    height: 432
    radius: 16
    clip: true
    color: "transparent"

    property bool isVisible: false

    // MPRIS metadata
    property string trackTitle: "Nothing Playing"
    property string trackArtist: ""
    property string trackAlbum: ""
    property string artUrl: ""
    property real trackLength: 0
    property real trackPosition: 0
    property string playbackStatus: "Stopped"

    // Cava bars (20 bars, values 0-100)
    property var cavaBars: []

// ── Album art as blurred background ──────────────────────────────

    // 1. Source image — hidden, used as blur input
    Image {
        id: artImage
        anchors.fill: parent
        source: root.artUrl !== "" ? root.artUrl : ""
        fillMode: Image.PreserveAspectCrop
        visible: false
    }

    // 2. Blurred version — also hidden, used as mask input  
    MultiEffect {
        id: blurredArt
        source: artImage
        anchors.fill: artImage
        blurEnabled: true
        blur: 1.0
        blurMax: 20
        saturation: 0.3
        visible: false
    }

    // 3. Mask shape
    Rectangle {
        id: maskShape
        anchors.fill: parent
        radius: 16
        visible: false
        color: "black"
    }

    // 4. OpacityMask clips the blur to the rounded rectangle
    OpacityMask {
        anchors.fill: parent
        source: blurredArt
        maskSource: maskShape
    }

    // Dark overlay so text is readable over the blurred art
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.55)
        radius: 16
    }

    // ── Content ───────────────────────────────────────────────────────

    // Track info — pinned to top
    Column {
        id: trackInfo
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 20
        }
        spacing: 4

        Text {
            width: parent.width
            text: root.trackArtist
            font.family: "Rockstar Extra Bold"
            font.pixelSize: 30
            color: Theme.get.artistFont
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
        }

        Text {
            id: titleText
            width: parent.width
            text: root.trackTitle
            font.family: "TR Impact"
            font.pixelSize: 22
            font.weight: Font.Bold
            color: Theme.get.songFont
            elide: Text.ElideRight
        }

        Text {
            width: parent.width
            text: root.trackAlbum
            font.family: "TR Impact"
            font.pixelSize: 15
            color: Theme.get.albumFont
            elide: Text.ElideRight
        }
    }

    // Controls + progress — pinned to bottom
    Column {
        id: bottomControls
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: 20
        }
        spacing: 8

        // Progress bar + timestamps
        Column {
            width: parent.width
            spacing: 6

            Rectangle {
                id: progressTrack
                width: parent.width
                height: 4
                radius: 2
                color: Qt.rgba(1, 1, 1, 0.2)

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: root.trackLength > 0
                        ? progressTrack.width * Math.min(root.trackPosition / root.trackLength, 1.0)
                        : 0
                    radius: 2
                    color: Theme.get.accent
                }
            }

            Row {
                width: parent.width

                Text {
                    text: formatTime(root.trackPosition)
                    font.family: "Sen"
                    font.pixelSize: 11
                    color: Qt.rgba(1, 1, 1, 0.6)
                }

                Item { width: parent.width - posLabel.width - durLabel.width; height: 1 }

                Text {
                    id: durLabel
                    text: formatTime(root.trackLength)
                    font.family: "Sen"
                    font.pixelSize: 11
                    color: Qt.rgba(1, 1, 1, 0.6)
                }
            }
        }

        // Playback controls
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 32

            Text {
                text: "⏮"
                font.pixelSize: 24
                color: Qt.rgba(1, 1, 1, 0.85)
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: prevProcess.running = true
                }
            }

            Text {
                text: root.playbackStatus === "Playing" ? "⏸" : "▶"
                font.pixelSize: 28
                color: "white"
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: playPauseProcess.running = true
                }
            }

            Text {
                text: "⏭"
                font.pixelSize: 24
                color: Qt.rgba(1, 1, 1, 0.85)
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: nextProcess.running = true
                }
            }
        }
    }

    // Cava visualiser — fills the space between track info and controls
    Canvas {
        id: cavaCanvas
        anchors {
            top: trackInfo.bottom
            bottom: bottomControls.top
            left: parent.left
            right: parent.right
            topMargin: 40
            leftMargin: 20
            rightMargin: 20
            bottomMargin: 8
        }

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()

            if (root.cavaBars.length === 0) return

            var bars = root.cavaBars
            var count = bars.length
            var gap = 3
            var barW = (width - (gap * (count - 1))) / count

            for (var i = 0; i < count; i++) {
                var val = bars[i] / 100
                var barH = val * height
                var x = i * (barW + gap)
                var y = height - barH

                var hex = Theme.get.audioAccent.toString().replace("#", "")
                var r = parseInt(hex.substring(0, 2), 16)
                var g = parseInt(hex.substring(2, 4), 16)
                var b = parseInt(hex.substring(4, 6), 16)
                var acSolid = "rgba(" + r + "," + g + "," + b + ",1.0)"
                var acFade  = "rgba(" + r + "," + g + "," + b + ",0.15)"

                var grad = ctx.createLinearGradient(x, y, x, height)
                grad.addColorStop(0, acSolid)
                grad.addColorStop(1, acFade)

                ctx.fillStyle = grad
                ctx.beginPath()
                ctx.roundedRect(x, y, barW, barH, 2, 2)
                ctx.fill()
            }
        }

        Connections {
            target: root
            function onCavaBarsChanged() {
                cavaCanvas.requestPaint()
            }
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────
    function formatTime(secs) {
        var s = Math.floor(secs)
        var m = Math.floor(s / 60)
        s = s % 60
        return m + ":" + (s < 10 ? "0" : "") + s
    }

    // Metadata timer — every 5s is enough for track changes
    Timer {
        interval: 5000
        running: root.isVisible
        repeat: true
        triggeredOnStart: true
        onTriggered: metadataProcess.running = true
    }

    // Local position tracking — Plexamp doesn't report MPRIS position
    property real trackStartTime: 0  // Date.now() when play began
    property real pausedPosition: 0  // position saved when paused

    onPlaybackStatusChanged: {
        if (playbackStatus === "Playing") {
            // Resume: record wall-clock start offset by paused position
            trackStartTime = Date.now() - (pausedPosition * 1000)
        } else if (playbackStatus === "Paused") {
            // Save current position before pausing
            pausedPosition = trackPosition
        } else {
            // Stopped
            pausedPosition = 0
            trackPosition = 0
        }
    }

    onTrackTitleChanged: {
        // New track — reset
        pausedPosition = 0
        trackStartTime = Date.now()
        trackPosition = 0
    }

    // Position timer — update every second from wall clock
    Timer {
        interval: 1000
        running: root.isVisible && root.playbackStatus === "Playing"
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (root.trackStartTime > 0) {
                var elapsed = (Date.now() - root.trackStartTime) / 1000
                root.trackPosition = Math.min(elapsed, root.trackLength)
            }
        }
    }

    Process {
        id: metadataProcess
        command: ["sh", "-c",
            "playerctl -p Plexamp status && " +
            "playerctl -p Plexamp metadata xesam:title && " +
            "playerctl -p Plexamp metadata xesam:artist && " +
            "playerctl -p Plexamp metadata xesam:album && " +
            "playerctl -p Plexamp metadata mpris:length && " +
            "playerctl -p Plexamp metadata mpris:artUrl"
        ]
        running: false
        property string buffer: ""
        property int lineIndex: 0

        stdout: SplitParser {
            onRead: data => {
                metadataProcess.buffer += data + "\n"
            }
        }

        onRunningChanged: {
            if (!running && buffer !== "") {
                var lines = buffer.trim().split("\n").filter(l => l !== "")
                console.log("METADATA lines count:", lines.length)
                lines.forEach((l, i) => console.log("METADATA[" + i + "]:", l))
                if (lines.length >= 6) {
                    root.playbackStatus = lines[0].trim()
                    root.trackTitle     = lines[1].trim()
                    root.trackArtist    = lines[2].trim()
                    root.trackAlbum     = lines[3].trim()
                    root.trackLength    = parseInt(lines[4].trim()) / 1000000
                    var art = lines[5].trim()
                    root.artUrl = art.startsWith("file://") ? art.substring(7) : art
                    console.log("METADATA assigned — length:", root.trackLength, "status:", root.playbackStatus)
                }
                buffer = ""
            } else if (running) {
                buffer = ""
            }
        }
    }

// ── Controls ──────────────────────────────────────────────────────
    Process {
        id: playPauseProcess
        command: ["playerctl", "-p", "Plexamp", "play-pause"]
        running: false
    }

    Process {
        id: nextProcess
        command: ["playerctl", "-p", "Plexamp", "next"]
        running: false
    }

    Process {
        id: prevProcess
        command: ["playerctl", "-p", "Plexamp", "previous"]
        running: false
    }

    // ── Cava ──────────────────────────────────────────────────────────
    property string cavaConfig: `
[general]
bars = 20

[input]
method = pulse
source = alsa_output.pci-0000_03_00.6.analog-stereo.monitor

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 100
`

    Process {
        id: cavaProcess
        command: ["sh", "-c", "echo '" + root.cavaConfig + "' | cava -p /dev/stdin"]
        running: root.isVisible

        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                var line = data.trim()
                if (line === "") return
                var parts = line.split(";").filter(s => s !== "")
                var all = parts.map(s => parseInt(s) || 0)
                // Output is stereo mirrored — left channel is first half
                var bars = all.slice(0, Math.floor(all.length / 2))
                if (bars.length > 0) root.cavaBars = bars
            }
        }
    }

    // ── Position label anchor fix ─────────────────────────────────────
    // (posLabel is referenced in the Row but needs an id)
    Text {
        id: posLabel
        visible: false
        text: formatTime(root.trackPosition)
        font.family: "Sen"
        font.pixelSize: 11
    }
}
