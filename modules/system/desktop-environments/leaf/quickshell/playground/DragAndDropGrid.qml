
import QtQuick
import Quickshell

FloatingWindow {
    id: root
    color: "grey"

    component GridItem: MouseArea {
        id: gridItem
        required property var grid // the grid parent
        property int targetRow: {
            let proposedRow = Math.round(y / grid.unitSize)
            let validRow = proposedRow >= grid.numRows ? grid.numRows - 1 : proposedRow
            return validRow
        }
        property int targetColumn: {
            let proposedCol = Math.round(x / grid.unitSize)
            let validCol = proposedCol >= grid.numColumns ? grid.numColumns - 1 : proposedCol
            return validCol
        }
        drag.target: gridItem
        // Moves the client to the top compared to it's sibling clients
        drag.onActiveChanged: () => drag.active ? gridItem.z = 1 : gridItem.z = 0
        onPressed: {
            grid.selectedItem = gridItem
        }
        onReleased: {
            x = targetColumn * grid.unitSize
            y = targetRow * grid.unitSize
            grid.selectedItem = null
        }

    }

    component GridArea: Rectangle {
        id: grid
        required property list<var> items
        property int unitSize: 64
        property int numRows: 4
        property int numColumns: 8
        property GridItem selectedItem: null
        color: "black"
        width: unitSize * numColumns
        height: unitSize * numRows

        Item {
            id: targetGhost
            x: selectedItem?.targetColumn * grid.unitSize
            y: selectedItem?.targetRow * grid.unitSize
            visible: grid.selectedItem != null
            width: selectedItem?.width
            height: selectedItem?.height
            Rectangle {
                color: "white"
                anchors.fill: parent
                anchors.margins: 8
            }
        }

        Repeater {
            model: root.gridItems
            delegate: GridItem {
                required property var modelData
                grid: parent
                x: modelData.col * grid.unitSize
                y: modelData.row * grid.unitSize
                width: modelData.w * grid.unitSize
                height: modelData.h * grid.unitSize

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4
                    color: "red"
                }
            }
        }
    }

    property list<var> gridItems: [
        {
            row: 0,
            col: 0,
            w: 1,
            h: 1
        },
        {
            row: 2,
            col: 3,
            w: 2,
            h: 1
        }
    ]

    GridArea {}
}
