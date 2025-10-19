pragma ComponentBehavior: Bound

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
        signal positionUpdated(id: string, row: int, column: int)
        required property GridArea parentGrid // the grid parent
        required property var gridItemDef // persisted JSON representing the item props

        property string widgetId: gridItemDef.id
        property int cellColumnSpan: gridItemDef.w
        property int cellRowSpan: gridItemDef.h
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

        // Position & Size
        x: gridItemDef.col * parentGrid.unitSize
        y: gridItemDef.row * parentGrid.unitSize
        width: gridItemDef.w * parentGrid.unitSize
        height: gridItemDef.h * parentGrid.unitSize

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
            isValid = parentGrid.model.every(i => {
                // Don't set invalid if widget overlaps with self
                if (i.id == widgetId) { return true }
                return !doItemsOverlap(
                    Qt.point(targetColumn, targetRow), Qt.point(targetColumn + cellColumnSpan, targetRow + cellRowSpan),
                    Qt.point(i.col, i.row), Qt.point(i.col + i.w, i.row + i.h)
                )
            })
            console.log(`isValid: ${isValid}`)
            if (isValid) {
                x = targetColumn * parentGrid.unitSize
                y = targetRow * parentGrid.unitSize

                //positionUpdated(widgetId, targetRow, targetColumn)

                let widgetDef = parentGrid.model.find(i => i.id === widgetId)
                widgetDef.row = targetRow
                widgetDef.col = targetColumn
                parentGrid.modelUpdated(parentGrid.model)
            }
            else {
                x = initialX
                y = initialY
            }
            parentGrid.selectedItem = null
        }
    }

    component GridArea: Rectangle {
        id: grid
        signal modelUpdated(model: list<var>)
        required property list<var> model
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
            model: grid.model
            delegate: GridItem {
                id: gridItem
                required property var modelData
                gridItemDef: modelData
                parentGrid: grid
                Loader {
                    anchors.fill: parent
                    property Component item1: Rectangle {
                        anchors.fill: parent
                        anchors.margins: 4
                        color: "red"
                    }
                    property Component item2: Rectangle {
                        anchors.fill: parent
                        anchors.margins: 4
                        color: "blue"
                    }
                    property Component item3: Rectangle {
                        anchors.fill: parent
                        anchors.margins: 4
                        color: "green"
                    }
                    sourceComponent: {
                        switch(gridItem.modelData.widgetId) {
                            case "item1":
                                return item1
                            case "item2":
                                return item2
                            case "item3":
                                return item3
                            default:
                                return null
                        }
                    }
                }
            }
        }
    }


    RowLayout {
        Button {
            text: "add"
            onClicked: root.widgets.push({
                id: Math.random().toString().substr(2),
                widgetId: "item1",
                row: 0, col: 0, w: 1, h: 1
            })
        }
        Button {
            text: "add long"
            onClicked: root.widgets.push({
                id: Math.random().toString().substr(2),
                widgetId: "item2",
                row: 0, col: 0, w: 2, h: 1
            })
        }
        Button {
            text: "add big"
            onClicked: root.widgets.push({
                id: Math.random().toString().substr(2),
                widgetId: "item3",
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
        x: 40
        y: 40

        model: root.widgets
        // Hanlder for updating source model
        onModelUpdated: (model) => root.widgets = model
    }
}
