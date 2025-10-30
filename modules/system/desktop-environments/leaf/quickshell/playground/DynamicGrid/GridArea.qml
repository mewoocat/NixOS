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
        if (!selectedItem) { return -1 }
        let proposedRow = Math.round(selectedItem.y / unitSize)
        let maxAllowedRow = numRows - selectedItem.cellRowSpan 
        if (proposedRow > maxAllowedRow) { return maxAllowedRow }
        if (proposedRow < 0) { return 0 }
        return proposedRow
    }
    property int selectedTargetColumn: {
        if (!selectedItem) { return -1 }
        let proposedCol = Math.round(selectedItem.x / unitSize)
        let maxAllowedCol = numColumns - selectedItem.cellColumnSpan
        if (proposedCol > maxAllowedCol) { return maxAllowedCol }
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
                console.log(`selectedRow: ${grid.selectedTargetRow}`)
                console.log(`selectedCol: ${grid.selectedTargetColumn}`)

                /*
                const noOverlap = grid.model.every(i => {
                    // Don't set invalid if widget overlaps with self
                    if (i.id === modelData.id) { return true }
                    return !doItemsOverlap(
                        Qt.point(selectedTargetColumn, selectedTargetRow),
                        Qt.point(selectedTargetColumn + cellColumnSpan, selectedTargetRow + cellRowSpan),
                        Qt.point(i.col, i.row),
                        Qt.point(i.col + i.w, i.row + i.h)
                    )
                })
                */

                const intersectingItems = grid.model.filter(i => {
                    // Don't set invalid if widget overlaps with self
                    if (i.id === modelData.id) { return false }
                    return doItemsOverlap(
                        Qt.point(selectedTargetColumn, selectedTargetRow),
                        Qt.point(selectedTargetColumn + cellColumnSpan, selectedTargetRow + cellRowSpan),
                        Qt.point(i.col, i.row),
                        Qt.point(i.col + i.w, i.row + i.h)
                    )
                })

                console.log(JSON.stringify(intersectingItems, null, 4))

                const noOverlap = intersectingItems.length == 0

                // If no overlap then no rearrangement needs to occur
                if (noOverlap) {
                    // Snap the item to the proposed position
                    x = grid.selectedTargetColumn * grid.unitSize
                    y = grid.selectedTargetRow * grid.unitSize

                    // Get the definition for currently moved item and update it
                    const widgetDef = grid.model.find(i => i.id === modelData.id)
                    widgetDef.row = grid.selectedTargetRow
                    widgetDef.col = grid.selectedTargetColumn
                    
                    // Trigger updated signal
                    grid.modelUpdated(grid.model)

                    grid.selectedItem = null
                    return
                }

                // If rearrangement does need to occur 
                const oldRow = row
                const oldCol = column
                const newRow = grid.selectedTargetRow
                const newCol = grid.selectedTargetColumn

                console.log(`oldRow: ${oldRow} oldCol: ${oldCol}`)
                console.log(`newRow: ${newRow} newCol: ${newCol}`)

                intersectingItems.forEach(item => {
                    const intersectingWidgetDef = grid.model.find(def => def.id === item.id)
                    const intersectingWidgetItem = grid.children.find(childItem => childItem.id = item.id)
                    // Need to determine the direction to move the intersecting item
                    // find midpoint of moved item relative to grid
                    const movedMidpoint = {
                        x: x / width,
                        y: y / height
                    }
                    // find midpoint of intersecting item relative to grid
                    // TODO: Double check the math
                    const intersectingMidPoint = {
                        x: intersectingWidgetItem.x + (intersectingWidgetItem.width / 2),
                        y: intersectingWidgetItem.y + (intersectingWidgetItem.height / 2)
                    }
                    // find which side of the intersecting item the midpoint is closest to
                    const xDirection = movedMidpoint.x < intersectingMidPoint.x ? 1 : -1
                    const yDirection = movedMidpoint.y < intersectingMidPoint.y ? 1 : -1

                    /*
                    intersectingWidgetDef.row += 0
                    intersectingWidgetDef.col += 1
                    */
                })
                // Trigger updated signal
                grid.modelUpdated(grid.model)

                // Get the definition for currently moved item and update it
                const widgetDef = grid.model.find(i => i.id === modelData.id)
                widgetDef.row = grid.selectedTargetRow
                widgetDef.col = grid.selectedTargetColumn
                return

                // Move failure
                x = initialX
                y = initialY
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
