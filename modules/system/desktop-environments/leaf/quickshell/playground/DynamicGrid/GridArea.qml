pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: grid
    signal modelUpdated(model: list<var>)
    required property list<var> model
    //required property var instMap // Object which maps widget uid's to their instance data
    required property list<WidgetDef> availableWidgets

    property int unitSize: 64
    property int numRows: 8
    property int numColumns: 4
    property GridItem selectedItem: null
    readonly property int selectedXPos: {
        if (!selectedItem) { return -1 }
        let proposedXPos = Math.round(selectedItem.x / unitSize)
        let maxAllowedXPos = numColumns - selectedItem.widgetInst.xSpan
        if (proposedXPos > maxAllowedXPos) { return maxAllowedXPos }
        if (proposedXPos < 0) { return 0 }
        return proposedXPos
    }
    readonly property int selectedYPos: {
        if (!selectedItem) { return -1 }
        let proposedYPos = Math.round(selectedItem.y / unitSize)
        let maxAllowedYPos = numColumns - selectedItem.cellColumnSpan
        if (proposedYPos > maxAllowedYPos) { return maxAllowedYPos }
        if (proposedYPos < 0) { return 0 }
        return proposedYPos
    }
    width: unitSize * numColumns
    height: unitSize * numRows
    color: "black"

    // Returns an object representing an instance of a widget
    function generateWidgetInst(widgetId: string, xPos: int, yPos: int, xSpan: int, ySpan: int): var {
        return {
            uid: Math.random().toString().substr(2), // Generate random string (probably unique)
            widgetId: widgetId,
            xPos: xPos,
            yPos: yPos,
            xSpan: xSpan,
            ySpan: ySpan
        }
    }

    // Returns the first valid spot of null if one doesn't exist for a given 
    // widget def
    function findSpot(def: WidgetDef): var {
        // Iterate over each possible spot
        for (let xPos = 0; xPos <= numColumns - def.xSpan; xPos++) {
            for (let yPos = 0; yPos <= numRows - def.ySpan; yPos++) {
                // Check a new defintion of a widget can fit with the existing instances
                let isValid = grid.model.every(inst => !doItemsOverlap(
                    Qt.point(xPos, yPos),
                    Qt.point(xPos + def.xSpan, yPos + def.ySpan),
                    Qt.point(inst.xPos, inst.yPos),
                    Qt.point(inst.xPos + inst.xSpan, inst.yPos + inst.ySpan)
                ))
                if (isValid) {
                    return Qt.point(col, row)
                }
            }
        }
        return null
    }

    // Checks if the widget instance overlaps with any other widget instances.
    // Takes in a widget instance, the proposed x/y position, and the model.
    function isPositionOverlapping(inst: var, xPos: int, yPos: int, model: var): bool { 
        // Ensure this new position won't cause the item to overlap with any other items
        const isIntersecting = model
            .filter(existingInst => existingInst.uid !== inst.uid) // Don't check self
            .every(existingInst => !doItemsOverlap(
                Qt.point(xPos, yPos),
                Qt.point(xPos + inst.xSpan, yPos + inst.ySpan),
                Qt.point(existingInst.xPos, existingInst.yPos),
                Qt.point(existingInst.xPos + existingInst.xSpan, existingInst.yPos + existingInst.ySpan)
            ))
        return isIntersecting
    }

    // Checks if the position for the instance is within the bounds of the grid
    // Takes in a widget instance and the proposed x and y position.
    function isPositionInBounds(inst: var, x: int, y: int): bool {
        const inBounds =
            inst.xPos >= 0 &&
            inst.xPos + inst.xSpan < grid.numColumns &&
            inst.yPos >= 0 &&
            inst.yPos + inst.yPos < grid.numRows;
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

    // Given a widget instance uid and model, get the instance data
    function getWidgetInst(uid: string): var {
        const widgetdef = grid.model.find(def => {
            return def.id === widgetId
        })
        return widgetdef
    }

    function getWidgetItem(uid: string): Item {
        const item = grid.children.find(i => i.uid === uid)
        return item
    }

    //
    function moveWidget(item: GridItem, xPos: int, yPos: int, model: var) {
        inst = getWidgetInst(item.widgetInst.uid, model)
        //const inst = item.widgetInst

        // Snap the item to the proposed position
        item.x = xPos * grid.unitSize
        item.y = yPos * grid.unitSize

        // Update the widget instance in the model
        inst.xPos = xPos
        inst.yPos = yPos

        // Trigger updated signal
        //grid.modelUpdated(grid.model)
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
            uid: Math.random().toString().substr(2), // Generate random string (probably unique)
            widgetId: widgetId,
            x: pos.x, 
            y: pos.y,
            w: widgetDef.cellColumnSpan,
            h: widgetDef.cellRowSpan
        }

        grid.model.push(jsonDef)
        grid.modelUpdated(grid.model)
    }

    Item {
        id: targetGhost
        x: grid.selectedXPos * grid.unitSize
        y: grid.selectedYPos * grid.unitSize
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
            widgetInst: modelData

            onItemSelected: (item) => grid.selectedItem = item
            onPositionChanged: (item) => console.log(`item ${item.uid} position changed`)
            onPositionUpdateRequested: (item) => {
                // Clone the model to attempt to place the item and perform any rearranging
                var modelClone = JSON.parse(JSON.stringify(grid.model))

                const intersectingInsts = modelClone.filter(intersectingInst => {
                    // Don't count if widget overlaps with self
                    if (intersectingInsts.uid === widgetInst.uid) { return false }
                    return doItemsOverlap(
                        Qt.point(selectedXPos, selectedYPos),
                        Qt.point(selectedXPos + selectedItem.widgetInst.xSpan, selectedYPos + selectedItem.widgetInst.ySpan),
                        Qt.point(intersectingInst.xPos, intersectingInst.yPos),
                        Qt.point(intersectingInst.xPos + intersectingInst.xSpan, intersectingInst.yPos + intersectingInst.ySpan)
                    )
                })
                console.log(JSON.stringify(intersectingDefs, null, 4))

                const noOverlap = intersectingDefs.length == 0

                // If no overlap then no rearrangement needs to occur
                if (noOverlap) {
                    moveWidget(item.uid, grid.selectedTargetColumn, grid.selectedTargetRow)
                    grid.selectedItem = null
                    grid.modelUpdated(modelClone)
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
                property Component widget: grid.availableWidgets.find(def => def.widgetId === gridItem.widgetInst.widgetId).content
                sourceComponent: widget
            }
        }
    }
}
