
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

FloatingWindow {
    id: root
    color: "grey"

    property list<var> widgets: []

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
        required property GridArea parentGrid // the grid parent
        required property string widgetId // the config object
        required property int cellColumnSpan
        required property int cellRowSpan
        property int initialX: 0
        property int initialY: 0
        property int targetRow: {
            let proposedRow = Math.round(y / parentGrid.unitSize)
            if (proposedRow > parentGrid.numRows - 1) { return parentGrid.numRows - 1 }
            if (proposedRow < 0) { return 0 }
            return proposedRow
        }
        property int targetColumn: {
            let proposedCol = Math.round(x / parentGrid.unitSize)
            if (proposedCol > parentGrid.numColumns - 1) { return parentGrid.numColumns - 1 }
            if (proposedCol < 0) { return 0 }
            return proposedCol
        }
        drag.target: gridItem
        // Moves the client to the top compared to it's sibling clients
        drag.onActiveChanged: () => drag.active ? gridItem.z = 1 : gridItem.z = 0
        onPressed: {
            parentGrid.selectedItem = gridItem
            // Store original position
            initialX = gridItem.x
            initialY = gridItem.y
        }
        onReleased: {
            let isValid = true
            console.log(`parentGrid.items: ${JSON.stringify(parentGrid.items)}`)
            isValid = parentGrid.items.every(i => {
                // Don't set invalid if widget overlaps with self
                if (i.id == widgetId) { return true }
                return !doItemsOverlap(
                    Qt.point(targetColumn, targetRow), Qt.point(targetColumn + cellColumnSpan, targetRow + cellRowSpan),
                    Qt.point(i.col, i.row), Qt.point(i.col + i.w, i.row + i.h)
                )
                /*
                console.log(`i: ${JSON.stringify(i,null,4)}`)
                console.log(`targetRow: ${targetRow}`)
                console.log(`targetColumn: ${targetColumn}`)
                const rowBlocked = targetRow >= i.row && targetRow < i.row + i.h
                const columnBlocked = targetColumn >= i.col && targetColumn < i.col + i.w
                console.log(rowBlocked)
                console.log(columnBlocked)
                return !rowBlocked || !columnBlocked
                */
            })
            console.log(`isValid: ${isValid}`)
            if (isValid) {
                x = targetColumn * parentGrid.unitSize
                y = targetRow * parentGrid.unitSize
            }
            else {
                x = initialX
                y = initialY
            }
            console.log("widgets-pre: " + JSON.stringify(parentGrid.items))
            let widgetDef = parentGrid.items.find(i => i.id === widgetId)
            //console.log(`found: ${widgetDef}`)
            widgetDef.row = targetRow
            widgetDef.col = targetColumn
            console.log("widgets-post: " + JSON.stringify(parentGrid.items))
            parentGrid.selectedItem = null
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
                parentGrid: grid
                widgetId: modelData.id
                cellColumnSpan: modelData.w
                cellRowSpan: modelData.h
                x: modelData.col * grid.unitSize
                y: modelData.row * grid.unitSize
                width: modelData.w * grid.unitSize
                height: modelData.h * grid.unitSize
                Component.onCompleted: console.log(`id: ${modelData.id}`)

                Rectangle {
                    anchors.fill: parent
                    anchors.margins: 4
                    color: "red"
                }
            }
        }
    }


    RowLayout {
        Button {
            text: "add"
            onClicked: root.widgets.push({
                id: Math.random().toString().substr(2),
                row: 0, col: 0, w: 1, h: 1
            })
        }
        Button {
            text: "add big"
            onClicked: root.widgets.push({
                id: Math.random().toString().substr(2),
                row: 0, col: 0, w: 2, h: 2
            })
        }
        Button {
            text: "root.widgets"
            onClicked: console.log(JSON.stringify(root.widgets,null,4))
        }
    }

    GridArea {
        id: area
        items: root.widgets
        x: 40
        y: 40
    }
}
