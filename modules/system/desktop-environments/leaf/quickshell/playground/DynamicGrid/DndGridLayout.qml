pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

// I don't think this'll work
FloatingWindow {
    color: "black"

    Rectangle {
        width: 300
        height: 300
        color: "grey"
        GridLayout {
            id: grid
            property int unitSize: 25
            anchors.fill: parent
            rows: 12
            columns: 12
            uniformCellWidths: true
            uniformCellHeights: true


            Rectangle {
                color: "green"
                implicitWidth: grid.unitSize
                implicitHeight: grid.unitSize
                Layout.row: 1
                Layout.column: 1
            }
            Rectangle {
                color: "green"
                implicitWidth: grid.unitSize
                implicitHeight: grid.unitSize
                Layout.row: 1
                Layout.column: 1
            }
        }
    }
}
