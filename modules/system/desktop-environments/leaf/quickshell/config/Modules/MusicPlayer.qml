import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.Modules.Common as Common

GridLayout {
    id: root
    anchors.fill: parent
    rows: 3
    columns: 4
    rowSpacing: 0
    columnSpacing: 0

    property int currentPlayerIndex: {
        // Find first playing player
        let index = Mpris.players.values.findIndex(player => player.isPlaying)
        // If no player is playing select the first player
        if (index === -1) {
            index = 0
        }
        return index
    }
    property MprisPlayer currentPlayer: {
        // If there are no players
        if (Mpris.players.values.length < 1) {
            return null
        }
        return Mpris.players.values[currentPlayerIndex]
    }
    property int maxTextWidth: 200

    IconImage {
        id: image
        implicitSize: parent.height
        source: root.currentPlayer !== null || root.currentPlayer.trackArtUrl !== "" ? root.currentPlayer.trackArtUrl : "file:/home/eXia/Nextcloud/PicturesAndVideos/cat.jpg"
        Layout.columnSpan: 1
        Layout.rowSpan: 4
    }

    ColumnLayout {
        Layout.columnSpan: 1
        Layout.rowSpan: 1
        Layout.row: 0
        Layout.column: 1
        Layout.topMargin: 12
        Layout.leftMargin: 12
        
        Text {
            id: title
            elide: Text.ElideRight // Truncate with ... on the right
            Layout.preferredWidth: root.maxTextWidth // Width needs to be set for truncation to work
            text: root.currentPlayer.trackTitle
            color: palette.text
        }
        Text {
            id: artist
            text: root.currentPlayer.trackArtist
            elide: Text.ElideRight // Truncate with ... on the right
            Layout.preferredWidth: root.maxTextWidth // Width needs to be set for truncation to work
            color: palette.text
            font.pointSize: 8
        }
    }

    ComboBox {
        textRole: "identity"
        model: Mpris.players.values // Not sure why the ObjectModel itself doesn't work
        displayText: "♫"
        implicitWidth: 54
        Layout.columnSpan: 1
        Layout.rowSpan: 1
        Layout.row: 0
        Layout.column: 3
        Component.onCompleted: popup.width = 160
        onActivated: (index) => {
            root.currentPlayerIndex = index
        }
    }

    Rectangle {
        color: "transparent"
        Layout.fillWidth: true
        implicitHeight: 32
        Layout.columnSpan: 3
        Layout.row: 1
        Layout.column: 1

        ProgressBar {
            id: progress
            anchors.left: parent.left
            anchors.right: parent.right

            // The position changed signal handler on the player isn't auto triggered due to performance reasons
            // This FrameAnimation element will signal that the position has changed whenever the player is playing 
            // at every frame interval
            // Also see: https://quickshell.org/docs/v0.2.0/types/Quickshell.Services.Mpris/MprisPlayer/#position
            FrameAnimation {
              // Only emit the signal when the position is actually changing
              running: root.currentPlayer.playbackState == MprisPlaybackState.Playing
              // Emit the positionChanged signal every frame.
              onTriggered: root.currentPlayer.positionChanged()
            }

            value: {
                if (!root.currentPlayer.lengthSupported || root.currentPlayerIndex.positionSupported) {
                    return 0
                }
                const normalizedPosition = root.currentPlayer.position / root.currentPlayer.length
                console.log(`pos: ${normalizedPosition}`)
                return normalizedPosition
            }
        }

        Text {
            anchors.left: progress.left
            anchors.top: progress.bottom
            id: timeRemaining
            color: palette.text
            font.pointSize: 8
            leftPadding: 8
            text: Math.ceil(root.currentPlayer.position)
        }

        Text {
            anchors.right: progress.right
            anchors.top: progress.bottom
            id: totalTime
            color: palette.text
            font.pointSize: 8
            rightPadding: 8
            text: Math.ceil(root.currentPlayer.length)
        }
    }


    RowLayout {
        Layout.columnSpan: 3
        Layout.row: 2
        Layout.column: 1
        Layout.alignment: Qt.AlignCenter
        Common.NormalButton {
            iconName: "player_rew"
            leftClick: () => root.currentPlayer.canGoPrevious ? root.currentPlayer.previous() : console.warn(`Current player can't go previous`)
        }
        Common.NormalButton {
            iconName: root.currentPlayer.playbackState === MprisPlaybackState.Playing ? "player_pause" : "player_play"
            leftClick: () => {
                if (!root.currentPlayer.canPlay || !root.currentPlayer.canPause) {
                    console.warn(`Current player can't play/pause`)
                    return
                }
                root.currentPlayer.playbackState === MprisPlaybackState.Playing ? root.currentPlayer.pause() : root.currentPlayer.play()
            }
        }
        Common.NormalButton {
            iconName: "player_fwd"
            leftClick: () => root.currentPlayer.canGoNext ? root.currentPlayer.next() : console.warn(`Current player can't go next`)
        }
    }

}
