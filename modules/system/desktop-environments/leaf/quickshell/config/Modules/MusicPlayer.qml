import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Mpris
import qs.Modules.Common as Common
import qs as Root

GridLayout {
    id: root
    anchors.fill: parent
    rows: 3
    columns: 4
    rowSpacing: 0
    columnSpacing: 0
    property int maxTextWidth: 200

    property int currentPlayerIndex: -1
    // Can be null if no players exist
    property MprisPlayer currentPlayer: {
        if (currentPlayerIndex === -1) {
            return null
        }
        return Mpris.players.values[currentPlayerIndex]
    }

    Connections {
        target: Mpris.players
        // Player added
        function onObjectInsertedPre(object, index) {
            console.log(`player added||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||`)
            // set this player as the active
            root.currentPlayerIndex = index
        }
        // Player removed
        function onObjectRemovedPre(object, index) {
            console.log(`player removed||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||`)
            // find and set another active player (if one exists)
            // otherwise set the first player or null if none exist
            root.currentPlayerIndex = root.findPlayingPlayer()
        }
    }

    /*
    Component.onCompleted: () => {
        // If there are players
        if (Mpris.players.values.length > 0) {
            const index = findPlayingPlayer()
            currentPlayer = players.list[index]
        }
    }
    */

    function findPlayingPlayer()
    {
        // If there are no players
        if (Mpris.players.list.length < 1) {
            return -1
        }
        // Find first playing player
        let index = Mpris.players.values.findIndex(player => player.isPlaying)
        // If no player is playing select the first player
        if (index === -1) {
            index = 0
        }
        return index
    }

    WrapperItem {
        Layout.columnSpan: 1
        Layout.rowSpan: 4
        margin: 8

        // To Round the corners of the image
        ClippingRectangle {
            radius: Root.State.rounding
            color: palette.window
            implicitHeight: root.height - (parent.margin * 2)
            implicitWidth: implicitHeight

            IconImage {
                id: image
                anchors.centerIn: parent
                implicitSize: artExists ? parent.height : parent.height - 24
                property bool artExists: root.currentPlayer !== null && root.currentPlayer.trackArtUrl !== ""
                source: artExists ? root.currentPlayer.trackArtUrl : Quickshell.iconPath("emblem-music-symbolic")
            }
        }
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
            text: {
                if (root.currentPlayer === null) { return "" }
                return root.currentPlayer.trackTitle || "Unknown Title"
            }
            color: palette.text
        }
        Text {
            id: artist
            text: {
                if (root.currentPlayer === null) { return "" }
                return root.currentPlayer.trackArtist || "Unknown Artist"
            }
            elide: Text.ElideRight // Truncate with ... on the right
            Layout.preferredWidth: root.maxTextWidth // Width needs to be set for truncation to work
            color: palette.text
            font.pointSize: 8
        }
    }

    ComboBox {
        enabled: root.currentPlayer !== null
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

        Slider {
            id: slider
            enabled: root.currentPlayer !== null
            //live: false
            anchors.left: parent.left
            anchors.right: parent.right
            property real futureValue: 0

            // The position changed signal handler on the player isn't auto triggered due to performance reasons
            // This FrameAnimation element will signal that the position has changed given the condition at every frame interval
            // Also see: https://quickshell.org/docs/v0.2.0/types/Quickshell.Services.Mpris/MprisPlayer/#position
            FrameAnimation {
              // Only emit the signal when the position is actually changing
              running: root.currentPlayer !== null && root.currentPlayer.playbackState == MprisPlaybackState.Playing && !slider.pressed
              // Emit the positionChanged signal every frame.
              onTriggered: root.currentPlayer.positionChanged()
            }
            value: {
                if (root.currentPlayer === null || !root.currentPlayer.lengthSupported || !root.currentPlayer.positionSupported) { return 0 }
                const normalizedPosition = root.currentPlayer.position / root.currentPlayer.length
                //console.log(`pos: ${normalizedPosition}`)
                return normalizedPosition
            }
            onMoved: () => {
                console.log(`value: ${value}`)
                if (root.currentPlayer === null || !root.currentPlayer.positionSupported || !root.currentPlayer.canSeek) { 
                    return
                }
                futureValue = value
            }
            onPressedChanged: {
                // If a release occured
                if (!pressed) {
                    root.currentPlayer.position = futureValue * root.currentPlayer.length
                }
            }
        }

        // Time passed
        Text {
            id: passedTime
            anchors.left: slider.left
            anchors.top: slider.bottom
            color: palette.text
            font.pointSize: 8
            leftPadding: 8
            text: {
                if (root.currentPlayer === null) { return 0 }
                return Common.Helpers.secToMinAndSec(Math.ceil(root.currentPlayer.position))
            }
        }

        // Total time
        Text {
            id: totalTime
            anchors.right: slider.right
            anchors.top: slider.bottom
            color: palette.text
            font.pointSize: 8
            rightPadding: 8
            text: {
                if (root.currentPlayer === null) { return 0 }
                return Common.Helpers.secToMinAndSec(Math.ceil(root.currentPlayer.length))
            }
        }
    }


    RowLayout {
        Layout.columnSpan: 3
        Layout.row: 2
        Layout.column: 1
        Layout.alignment: Qt.AlignCenter
        Common.NormalButton {
            iconName: "player_rew"
            leftClick: () => {
                if (root.currentPlayer === null) { console.warn(`No current player`); return }
                root.currentPlayer.canGoPrevious ? root.currentPlayer.previous() : console.warn(`Current player can't go previous`)
            }
        }
        Common.NormalButton {
            iconName: root.currentPlayer !== null && root.currentPlayer.playbackState === MprisPlaybackState.Playing ? "player_pause" : "player_play"
            leftClick: () => {
                if (root.currentPlayer === null) { console.warn(`No current player`); return }
                if (!root.currentPlayer.canPlay || !root.currentPlayer.canPause) {
                    console.warn(`Current player can't play/pause`)
                    return
                }
                root.currentPlayer.playbackState === MprisPlaybackState.Playing ? root.currentPlayer.pause() : root.currentPlayer.play()
            }
        }
        Common.NormalButton {
            iconName: "player_fwd"
            leftClick: () => 
            {
                if (root.currentPlayer === null) { console.warn(`No current player`); return }
                root.currentPlayer.canGoNext ? root.currentPlayer.next() : console.warn(`Current player can't go next`)
            }
        }
    }

}
