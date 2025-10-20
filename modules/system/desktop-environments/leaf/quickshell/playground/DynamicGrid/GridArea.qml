pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: grid
    signal modelUpdated(model: list<var>)
    required property list<var> model
    required property list<WidgetDef> availableWidgets

    property int unitSize: 64
    property int numRows: 4
    property int numColumns: 8
    property GridItem selectedItem: null
    property int selectedTargetRow: {
        if (!selectedItem) { return 0 }
        let proposedRow = Math.round(selectedItem.y / unitSize)
        if (proposedRow > numRows - 1) { return numRows - 1 }
        if (proposedRow < 0) { return 0 }
        return proposedRow
    }
    property int selectedTargetColumn: {
        if (!selectedItem) { return 0 }
        let proposedCol = Math.round(selectedItem.x / unitSize)
        if (proposedCol > numColumns - 1) { return numColumns - 1 }
        if (proposedCol < 0) { return 0 }
        return proposedCol
    }
    width: unitSize * numColumns
    height: unitSize * numRows
    color: "black"

    function findSpot(def: WidgetDef): var {
        // Iterate over each possible spot
        for (let row = 0; row <= numRows - def.cellRowSpan; row++) {
            for (let col = 0; col <= numColumns - def.cellColumnSpan; col++) {
                // Check if can fit the widget
                let isValid = grid.model.every(existingDef => !doItemsOverlap(
                    Qt.point(col, row),
                    Qt.point(col + def.cellColumnSpan, row + def.cellRowSpan),
                    Qt.point(existingDef.col, existingDef.row),
                    Qt.point(existingDef.col + existingDef.w, existingDef.row + existingDef.h)
                ))
                if (isValid) {
                    return Qt.point(col, row)
                }
            }
        }
        return null
    }

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

    function addWidget(widgetId: string) {
        console.log(`attempting to add: ${widgetId}`)
        const widgetDef = availableWidgets.find(def => def.widgetId === widgetId)
        if (!widgetDef) { console.error(`Could not add widget: ${widgetId}.  Could not find widget with the specified id`); return }

        const pos = findSpot(widgetDef)
        if (!pos) { console.error(`Could not add widget: ${widgetId}.  Position doesn't exist`); return }

        const jsonDef = {
            id: Math.random().toString().substr(2),
            widgetId: widgetId,
            row: pos.y, col: pos.x,
            w: widgetDef.cellColumnSpan,
            h: widgetDef.cellRowSpan
        }
        grid.model.push(jsonDef)
        grid.modelUpdated(grid.model)
    }

    Item {
        id: targetGhost
        x: grid.selectedTargetColumn * grid.unitSize
        y: grid.selectedTargetRow * grid.unitSize
        visible: grid.selectedItem != null
        width: grid.selectedItem?.width
        height: grid.selectedItem?.height
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
            unitSize: grid.unitSize
            row: modelData.row
            column: modelData.col
            cellRowSpan: modelData.h
            cellColumnSpan: modelData.w
            onItemSelected: (item) => grid.selectedItem = item

            onPositionUpdateRequested: (item) => {
                console.log(grid.model)
                console.log(`selectedRow: ${grid.selectedTargetRow}`)
                console.log(`selectedCol: ${grid.selectedTargetColumn}`)
                let isValid = true
                isValid = grid.model.every(i => {
                    // Don't set invalid if widget overlaps with self
                    if (i.id === modelData.id) { return true }
                    return !doItemsOverlap(
                        Qt.point(selectedTargetColumn, selectedTargetRow),
                        Qt.point(selectedTargetColumn + cellColumnSpan, selectedTargetRow + cellRowSpan),
                        Qt.point(i.col, i.row),
                        Qt.point(i.col + i.w, i.row + i.h)
                    )
                })
                console.log(`isValid: ${isValid}`)
                if (isValid) {
                    x = grid.selectedTargetColumn * grid.unitSize
                    y = grid.selectedTargetRow * grid.unitSize

                    let widgetDef = grid.model.find(i => i.id === modelData.id)
                    widgetDef.row = grid.selectedTargetRow
                    widgetDef.col = grid.selectedTargetColumn
                    grid.modelUpdated(grid.model)
                }
                else {
                    x = initialX
                    y = initialY
                }
                grid.selectedItem = null
            }
            Loader {
                id: loader
                anchors.fill: parent
                property Component widget: grid.availableWidgets.find(def => def.widgetId === gridItem.modelData.widgetId).content
                sourceComponent: widget
            }
        }
    }
}
