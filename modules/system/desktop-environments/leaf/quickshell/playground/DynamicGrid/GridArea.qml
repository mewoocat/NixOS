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

    // Checks if the def is moved to (x,y) if that position is valide
    function isPositionValid(def, x: int, y: int): bool { 
        // Ensure this new position won't cause the item to overlap with any other items
        let isValid = grid.model.every(existingDef => !doItemsOverlap(
            Qt.point(x, y),
            Qt.point(x + def.w, y + def.h),
            Qt.point(existingDef.col, existingDef.row),
            Qt.point(existingDef.col + existingDef.w, existingDef.row + existingDef.h)
        ))
        return isValid
    }

    function updatePosition(defId, col: int, row: int) {
        // get the definition for currently moved item and update it
        const widgetdef = grid.model.find(def => {
            def.id === defId
        })
        widgetdef.row = row
        widgetdef.col = col
        
        // Trigger updated signal
        grid.modelUpdated(grid.model)
    }

    // Determines whether two rectangles overlap given both of their top left most and bottom 
    // right most points.  This assumes x+ is right and y+ is down. Will return true if top left
    // point of B is less than the bottom right point of B and the bottom right point of B is 
    // greater than the top level point of A.
    function doItemsOverlap(A1, A2, B1, B2): bool {
        //console.log("[CHECKING] for overlap")
        if (
            A1.x < B2.x &&
            A1.y < B2.y && 
            A2.x > B1.x &&
            A2.y > B1.y
        ) {
            //console.log("overlap detected")
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
        id: repeater
        model: grid.model
        delegate: GridItem {
            id: gridItem
            required property var modelData
            unitSize: grid.unitSize
            row: modelData.row
            column: modelData.col
            cellRowSpan: modelData.h
            cellColumnSpan: modelData.w
            widgetId: modelData.widgetId
            uid: modelData.id
            onItemSelected: (item) => grid.selectedItem = item
            onPositionUpdateRequested: (item) => {
                const intersectingDefs = grid.model.filter(d => {
                    // Don't count if widget overlaps with self
                    if (d.id === modelData.id) { return false }
                    return doItemsOverlap(
                        Qt.point(selectedTargetColumn, selectedTargetRow),
                        Qt.point(selectedTargetColumn + cellColumnSpan, selectedTargetRow + cellRowSpan),
                        Qt.point(d.col, d.row),
                        Qt.point(d.col + d.w, d.row + d.h)
                    )
                })

                console.log(JSON.stringify(intersectingDefs, null, 4))

                const noOverlap = intersectingDefs.length == 0

                // If no overlap then no rearrangement needs to occur
                if (noOverlap) {
                    // Snap the item to the proposed position
                    x = grid.selectedTargetColumn * grid.unitSize
                    y = grid.selectedTargetRow * grid.unitSize

                    // get the definition for currently moved item and update it
                    console.log(`model: ${JSON.stringify(grid.model, null, 4)}`)
                    console.log(`looking for: ${gridItem.uid}`)
                    const widgetdef = grid.model.find(def => {
                        console.log(`checking ${JSON.stringify(def)}`)
                        return def.id === gridItem.uid
                    })
                    console.log(`widgetdef: ${JSON.stringify(widgetdef, null, 0)}`)
                    widgetdef.row = grid.selectedTargetRow
                    widgetdef.col = grid.selectedTargetColumn
                    
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

                // Need to move all intersecting items out of the way
                intersectingDefs.forEach(def => {
                    console.log(`def: ${JSON.stringify(def, null, 4)}`)
                    const intersectingItem = grid.children.find(i => i.uid === def.id)
                    console.log(`intersectingDef: ${def}`)
                    console.log(`intersectingItem: ${intersectingItem}`)

                    // Need to determine the direction to move the intersecting item
                    // find midpoint of moved item relative to grid
                    const movedMidpoint = {
                        x: (x + width) / 2,
                        y: (y + height) / 2
                    }
                    console.log(`movedMidpoint: ${JSON.stringify(movedMidpoint, null, 4)}`)

                    // find midpoint of intersecting item relative to grid
                    const intersectingMidPoint = {
                        x: (intersectingItem.x + intersectingItem.width) / 2,
                        y: (intersectingItem.y + intersectingItem.height) / 2
                    }
                    console.log(`intersectingMidpoint: ${JSON.stringify(intersectingMidPoint, null, 4)}`)

                    // find which side of the intersecting item the midpoint is closest to
                    const xDirection = movedMidpoint.x < intersectingMidPoint.x ? -1 : 1
                    const yDirection = movedMidpoint.y < intersectingMidPoint.y ? -1 : 1
                    console.log(`xDir: ${xDirection} | yDir ${yDirection}`)

                    // Search for an open position for this intersecting item in the x or y direction
                    // Try xDirection
                    if (isPositionValid(def, def.col + yDirection, def.row)) {
                        console.log(`found position with x`)
                    }
                    /*
                    // Try yDirection
                    if (isPositionValid(def, def.col, def.row + xDirection)) {
                        console.log(`found position with y`)
                        intersectingItem.x = (def.row + xDirection) * grid.unitSize
                        return 
                    }
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
