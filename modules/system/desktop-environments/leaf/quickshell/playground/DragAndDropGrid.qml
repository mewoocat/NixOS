
import QtQuick
import Quickshell

FloatingWindow {
    id: root
    color: "grey"

    // Determines whether two rectangles overlap given both of their top left most and bottom 
    // right most points.  This assumes x+ is right and y+ is down. Will return true if top left
    // point of B is less than the bottom right point of B and the bottom right point of B is 
    // greater than the top level point of A.
    function doItemsOverlap(A1, A2, B1, B2): bool {
        console.log("[CHECKING] for overlap")
        if (
            A1.x < B2.x &&
            A1.y < B2.y && 
            A2.x > B1.x &&
            A2.y > B1.y
        ) {
            console.log("overlap detected")
            return true
        }
        return false
    }

    component GridItem: MouseArea {
        id: gridItem
        required property var grid // the grid parent
        property int initialX: 0
        property int initialY: 0
        property int targetRow: {
            let proposedRow = Math.round(y / grid.unitSize)
            if (proposedRow > grid.numRows - 1) { return grid.numRows - 1 }
            if (proposedRow < 0) { return 0 }
            return proposedRow
        }
        property int targetColumn: {
            let proposedCol = Math.round(x / grid.unitSize)
            if (proposedCol > grid.numColumns - 1) { return grid.numColumns - 1 }
            if (proposedCol < 0) { return 0 }
            return proposedCol
        }
        drag.target: gridItem
        // Moves the client to the top compared to it's sibling clients
        drag.onActiveChanged: () => drag.active ? gridItem.z = 1 : gridItem.z = 0
        onPressed: {
            grid.selectedItem = gridItem
            // Store original position
            initialX = gridItem.x
            initialY = gridItem.y
        }
        onReleased: {
            let isValid = true
            /*
            grid.children.every(item => {
                if (item instanceof GridItem && item != gridItem) {
                    let topLeftA = Qt.point(item.x, item.y)
                    let bottomRightA = Qt.point(item.x + item.width, item.y + item.height)
                    let topLeftB = Qt.point(targetColumn * grid.unitSize, targetRow * grid.unitSize)
                    let bottomRightB = Qt.point(topLeftB.x + width, topLeftB.y + height)
                    console.log(`is griditem and not self`)
                    if (root.doItemsOverlap(topLeftA, bottomRightA, topLeftB, bottomRightB)) {
                        isValid = false
                        return false
                    }
                }
                return true
            })
            */
            console.log(Math.random())
            grid.items.every(i => {
                console.log(`i: ${JSON.stringify(i)}`)
                if (i.row == targetRow && i.col == targetColumn) {
                    isValid = false
                    return false
                }
            })
            if (isValid) {
                x = targetColumn * grid.unitSize
                y = targetRow * grid.unitSize
            }
            else {
                x = initialX
                y = initialY
            }
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
            model: grid.items
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


    GridArea {
        items: [
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
        x: 200
        y: 200
    }
}
