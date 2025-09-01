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
    rows: 4
    columns: 4
    rowSpacing: 0
    columnSpacing: 0
    //uniformCellWidths: true
    //uniformCellHeights: true

    property int margins: 16
    property MprisPlayer currentPlayer: Mpris.players.values[0]

    /*
    IconImage {
        id: image
        implicitSize: parent.height// - root.margins * 2
        //Layout.margins: root.margins
        source: "file:/home/eXia/Nextcloud/PicturesAndVideos/cat.jpg"
        Layout.columnSpan: 1
        Layout.rowSpan: 4
    }
    */
    Rectangle {
        color: "#99ff0000"
        Layout.row: 0
        Layout.rowSpan: 4
        Layout.column: 0
        Layout.columnSpan: 1
        Layout.fillHeight: true
        implicitWidth: height
        Text {
            text: `${parent.width} x ${parent.height}`
        }
    }

    Text {
        elide: Text.ElideRight // Truncate with ... on the right
        text: "title"//root.currentPlayer.trackTitle
        color: palette.text
        Layout.rowSpan: 1
        Layout.row: 0
        Layout.column: 1
    }

    Text {
        text: "artist " + root.currentPlayer.trackArtist
        color: palette.text
        font.pointSize: 8
        Layout.columnSpan: 1
        Layout.rowSpan: 1
        Layout.row: 1
        Layout.column: 1
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

        //background: Rectangle {
        //    implicitWidth: 40
        //    implicitHeight: 40
        //    radius: 16
        //    color: "black"
        //}
        //contentItem: Rectangle {
        //    width: 20
        //    implicitHeight: 20
        //    color: "green" 
        //}
        Component.onCompleted: {
            popup.width = 160
            console.log(`contentItem: ${contentItem.width}`)
            console.log(`background: ${background.width}`)
        }
        onActivated: (index) => {
            root.currentPlayer = Mpris.players.values[index] 
        }
    }

    ProgressBar {
        value: 0.4
        Layout.fillWidth: true
        Layout.row: 2
        Layout.columnSpan: 3
        Layout.column: 1
        //Layout.alignment: Qt.AlignBottom
    }


    Rectangle {
        color: "blue"
        implicitHeight: 10
        implicitWidth: 50
        Layout.row: 3
        Layout.column: 1
    }
    Rectangle {
        color: "blue"
        implicitHeight: 10
        implicitWidth: 50
        Layout.row: 3
        Layout.column: 3
    }

    /*
    Common.NormalButton {
        Layout.row: 3
        Layout.column: 1
        iconName: "player_rew"
    }
    Common.NormalButton {
        Layout.row: 3
        Layout.column: 2
        iconName: "player_play"
    }
    Common.NormalButton {
        Layout.row: 3
        Layout.column: 3
        iconName: "player_fwd"
    }
    */

}
