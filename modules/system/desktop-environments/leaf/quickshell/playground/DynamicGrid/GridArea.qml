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

    function isPositionOverlapping(def: var, x: int, y: int): bool { 
        // Ensure this new position won't cause the item to overlap with any other items
        let isIntersecting = grid.model
            .filter(existingDef => existingDef.id !== def.id) // Don't check self
            .every(existingDef => !doItemsOverlap(
                Qt.point(x, y),
                Qt.point(x + def.w, y + def.h),
                Qt.point(existingDef.col, existingDef.row),
                Qt.point(existingDef.col + existingDef.w, existingDef.row + existingDef.h)
            ))
        return isIntersecting
    }

    function isPositionInBounds(def: var, x: int, y: int): bool {
        let inBounds =
            def.col >= 0 &&
            def.col + def.w < grid.numColumns &&
            def.row >= 0 &&
            def.row + def.h < grid.numRows;
        return inBounds
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
    function getWidgetDef(widgetId: string): var {
        const widgetdef = grid.model.find(def => {
            return def.id === widgetId
        })
        return widgetdef
    }

    function getWidgetItem(widgetId: string): Item {
        const item = grid.children.find(i => i.uid === widgetId)
        return item
    }

    function moveWidget(widgetId: string, xCell: int, yCell: int) {
        const item = getWidgetItem(widgetId)
        // get the definition for currently moved item and update it
        const def = getWidgetDef(widgetId)
        console.log(`widgetdef: ${JSON.stringify(def, null, 0)}`)

        // Snap the item to the proposed position
        item.x = xCell * grid.unitSize
        item.y = yCell * grid.unitSize

        // Update the widget def
        def.row = yCell
        def.col = xCell

        // Trigger updated signal
        grid.modelUpdated(grid.model)
    }

    // WARNING: work in progess
    function recursiveRearrange(moveeId: string, collideeId: string, movedDirection: var, model: var): bool {

        const moveeDef = getWidgetDef(moveeId)
        const collideeDef = getWidgetDef(collideeId)
        console.log(`mveeId: ${moveeId}`)
        console.log(`collideeId: ${collideeId}`)

        let proposedX = collideeDef.col + movedDirection.x
        let proposedY = collideeDef.row + movedDirection.y

        // Move the collidee in the provided direction until it no longer collides
        // with the movee or hits a grid boundary
        let intersection = true
        while (intersection) {
            console.log(`intesection exists`)
            intersection = doItemsOverlap(
                Qt.point(moveeDef.col, moveeDef.row),
                Qt.point(moveeDef.col + moveeDef.w, moveeDef.row + moveeDef.h),
                Qt.point(proposedX, proposedY),
                Qt.point(collideeDef.col + collideeDef.w, collideeDef.row + collideeDef.h)
            )
            if (!intersection) {
                console.log(`no longer intesecting`)
                let inBounds = isPositionInBounds(collideeDef, proposedX, proposedY)
                if (inBounds) {
                    //moveWidget(col...)
                    console.log('found position for collidee thats in bounds')
                }
            }
            // Try another space over in the move direction
            else {
                proposedX += movedDirection.x
                proposedY += movedDirection.y
            }
        }

        // Find any widgets that intersect with the collidee after we moved it to 
        // stop colliding with the original movee.
        const intersectingDefs = model.filter(d => {
            // Don't count if widget overlaps with self
            if (d.id === collideeId.id) { return false }
            return doItemsOverlap(
                Qt.point(collideeDef.col, collideeDef.row),
                Qt.point(collideeDef.col + collideeDef.w, collideeDef.row + collideeDef.h),
                Qt.point(d.col, d.row),
                Qt.point(d.col + d.w, d.row + d.h)
            )
        })

        intersectingDefs.forEach(def => {    
            recursiveRearrange(collideeId, def.id, movedDirection, model)
        })

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
            onPositionChanged: (item) => console.log(`item ${item.uid} position changed`)
            onPositionUpdateRequested: (item) => {
                var modelClone = JSON.parse(JSON.stringify(grid.model))

                const intersectingDefs = modelClone.filter(d => {
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
                    moveWidget(item.uid, grid.selectedTargetColumn, grid.selectedTargetRow)
                    grid.selectedItem = null
                    return
                }

                // If rearrangement does need to occur 
                let validMove = false

                // Need to move all intersecting items out of the way
                intersectingDefs.forEach(def => {
                    console.log(`def: ${JSON.stringify(def, null, 4)}`)
                    const intersectingItem = getWidgetItem(def.id)

                    // Need to determine the direction to move the intersecting item
                    // find midpoint of moved item relative to grid
                    const movedMidpoint = {
                        x: (x + (x + width)) / 2,
                        y: (y + (y + height)) / 2
                    }
                    console.log(`movedMidpoint: ${JSON.stringify(movedMidpoint, null, 4)}`)

                    // find midpoint of intersecting item relative to grid
                    const intersectingMidPoint = {
                        x: (intersectingItem.x + (intersectingItem.x + intersectingItem.width)) / 2,
                        y: (intersectingItem.y + (intersectingItem.y + intersectingItem.height)) / 2
                    }
                    console.log(`intersectingMidpoint: ${JSON.stringify(intersectingMidPoint, null, 4)}`)

                    // find which x and y side of the intersecting item the midpoint is closest to
                    const xDirection = movedMidpoint.x < intersectingMidPoint.x ? -1 : 1
                    const yDirection = movedMidpoint.y < intersectingMidPoint.y ? -1 : 1
                    console.log(`xDir: ${xDirection} | yDir ${yDirection}`)

                    // find the distance diff (delta) between the x and y direction
                    const xDelta = Math.abs(movedMidpoint.x - intersectingMidPoint.x)
                    const yDelta = Math.abs(movedMidpoint.y - intersectingMidPoint.y)
                    console.log(`xDelta: ${xDelta} | yDelta: ${yDelta}`)

                    let direction
                    // find which direction to atempt a move
                    // Search for an open position for this intersecting item in the x or y direction
                    if (xDelta > yDelta) {
                        direction = {x: -xDirection, y: 0}
                    }
                    else {
                        direction = {x: 0, y: -yDirection}
                    }
                    console.log(`direction is ${direction}`)

                    recursiveRearrange(uid, def.id, direction, modelClone)
                })

                // Move failure
                if (!validMove) {
                    x = initialX
                    y = initialY
                }
                else {
                    // complete the move for the selected widget
                    moveWidget(gridItem.uid, selectedTargetColumn, selectedTargetRow)
                }

                // Trigger updated signal
                grid.modelUpdated(grid.model)
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
