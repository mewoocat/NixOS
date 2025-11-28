pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

// I don't think this'll work ... lets see .. yeah nvm
FloatingWindow {
    color: "black"

    Rectangle {
        width: 300
        height: 300
        color: "grey"
        GridLayout {
            id: grid
            property int unitSize: parent.height / rows
            anchors.fill: parent
            rows: 3
            columns: 3
            uniformCellWidths: true
            uniformCellHeights: true

            component GridItem: Rectangle {
                required property int xPos
                required property int yPos
                implicitWidth: grid.unitSize
                implicitHeight: grid.unitSize
                Layout.row: yPos
                Layout.column: xPos
                Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                //Layout.fillWidth: true
                //Layout.fillHeight: true
            }

            GridItem {
                color: "green"
                xPos: 1
                yPos: 1
            }
            GridItem {
                color: "blue"
                xPos: 1
                yPos: 2
            }
            GridItem {
                color: "yellow"
                xPos: 1
                yPos: 0
            }
            GridItem {
                color: "red"
                xPos: 0
                yPos: 0
            }
            
            // Placed at the lower right corner of the grid to force the number of rendered rows and columns
            // to the desired amount.  Otherwise the actual number of rows/columns will only be set to the 
            // item(s) with the highest row and column.
            GridItem {
                color: "transparent"
                xPos: 2
                yPos: 2
            }
        }
    }
}
