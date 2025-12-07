pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: grid
    signal modelUpdated(model: list<var>) // When a new model state has been confirmed
    signal modelInvalid() // When the model needs to be reset
    required property list<var> model
    required property list<WidgetDef> availableWidgets

    property int unitSize: 64
    property int xSize: 8
    property int ySize: 4
    property GridItem selectedItem: null
    property var targetInst: {
        if (!selectedItem) { return null }

        let proposedXPos = Math.round(selectedItem.x / unitSize)
        let maxXPos = xSize - selectedItem.xSpan
        if (proposedXPos > maxXPos) { proposedXPos = maxXPos }
        if (proposedXPos < 0) { proposedXPos = 0 }

        let proposedYPos = Math.round(selectedItem.y / unitSize)
        let maxYPos = ySize - selectedItem.ySpan
        if (proposedYPos > maxYPos) { proposedYPos = maxYPos }
        if (proposedYPos < 0) { proposedXPos = 0 }

        return generateWidgetInst(
            selectedItem.widgetId,
            proposedXPos, proposedYPos,
            selectedItem.xSpan, selectedItem.ySpan
        )
    }

    width: unitSize * xSize
    height: unitSize * ySize

    color: "black"

    function generateWidgetInst(widgetId: string, xPos: int, yPos: int, xSpan: int, ySpan: int, uid: string = null): var {
        return {
            uid: uid ?? Math.random().toString().substr(2), // Generate random string if none provided (probably unique)
            widgetId: widgetId,
            xPos: xPos, 
            yPos: yPos,
            xSpan: xSpan,
            ySpan: ySpan
        }
    }

    function addWidget(widgetId: string) {
        const widgetDef = availableWidgets.find(def => def.widgetId === widgetId)
        if (!widgetDef) { console.error(`Could not add widget: ${widgetId}.  Could not find widget with the specified id`); return }

        const pos = findSpot(widgetDef)
        if (!pos) { console.error(`Could not add widget: ${widgetId}.  Position doesn't exist`); return }

        const jsonInst = generateWidgetInst(widgetId, pos.x, pos.y, widgetDef.xSpan, widgetDef.xSpan)
        grid.model.push(jsonInst)
        grid.modelUpdated(grid.model)
    }

    // Returns the first valid spot of null if one doesn't exist for a given widget def
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

    // Checks if the widget instance overlaps with any other widget instances in the model.
    // Takes in a widget instance.
    function isPositionOverlapping(inst: var): bool { 
        // Ensure this new position won't cause the item to overlap with any other items
        const intersectingDefs = getIntersectingInsts(inst);
        return intersectingDefs.length > 0
    }

    // Gets all the widget instances in the model that intersect with the provided instance
    function getIntersectingInsts(inst: var): list<var> {
        return grid.model
            .filter(existingInst => {
                if (existingInst.uid === inst.uid) { return false } // Don't count self
                return doRectanglesOverlap( // Does existing inst overlap with provided inst
                    Qt.point(inst.xPos, inst.yPos),
                    Qt.point(inst.xPos + inst.xSpan, inst.yPos + inst.ySpan),
                    Qt.point(existingInst.xPos, existingInst.yPos),
                    Qt.point(existingInst.xPos + existingInst.xSpan, existingInst.yPos + existingInst.ySpan)
            )})
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
    function doRectanglesOverlap(A1, A2, B1, B2): bool {
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

    // Given a GridItem, get the instance object
    function GetInstForGridItem(item: GridItem): var {
        return generateWidgetInst(item.widgetId, item.xPos, item.yPos, item.xSpan, item.ySpan, item.uid)
    }

    // Given a widget instance uid, get the instance data
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
    function moveWidget(item: GridItem, xPos: int, yPos: int) {
        inst = getWidgetInst(item.widgetInst.uid)

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
    // TODO: I think we need to go back to model and moves system or similar, otherwise how do we let the 
    // original caller of this method know the final state of the grid, and can then construct the animations
    function recursiveRearrange(moveeInst: var, collideeInst: var, movedDirection: var, movedInsts: var): bool {

        let proposedX = collideeInst.xPos + movedDirection.x
        let proposedY = collideeInst.yPos + movedDirection.y

        // Move the collidee in the provided direction until it no longer collides with the movee or hits a grid boundary
        let intersection = true
        while (intersection) {
            console.log(`intesection exists`)
            intersection = doRectanglesOverlap(
                Qt.point(moveeInst.xPos, moveeInst.yPos),
                Qt.point(moveeInst.xPos + moveeInst.xSpan, moveeInst.yPos + moveeInst.ySpan),
                Qt.point(proposedX, proposedY),
                Qt.point(collideeInst.xPos + collideeInst.xSpan, collideeInst.yPos + collideeInst.ySpan)
            )
            if (!intersection) {
                console.log(`no longer intesecting`)
                let inBounds = isPositionInBounds(collideeInst, proposedX, proposedY)
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
        const intersectingDefs = getIntersectingInsts(collideeInst)

        // Recursively call to rearrange
        intersectingDefs.forEach(def => {    
            recursiveRearrange(collideeId, def.id, movedDirection, movedInsts)
        })
    }

    // Given a GridItem which has been dragged, attempt to calculate placing this item
    // in the closest desired location and rearrange any intersecting items
    function attemptArrange(item: GridItem) {
        const movedInsts = [] // A stack representing all the moves made on the model
        
        const itemInst = GetInstForGridItem(item)
        const intersectingInsts = getIntersectingInsts(itemInst)
        console.log(JSON.stringify(intersectingDefs, null, 4))

        // If no overlap then no rearrangement needs to occur
        const noOverlap = intersectingDefs.length == 0
        if (noOverlap) {
            moveWidget(item.uid, grid.selectedTargetColumn, grid.selectedTargetRow)
            grid.selectedItem = null
            grid.modelUpdated(grid.model)
            return
        }

        // Create clone of this inst and apply the move to it.
        // Then add this modified inst to move stack
        const itemInstClone = JSON.parse(JSON.stringify(itemInst))
        movedInsts.push(itemInst)

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

            recursiveRearrange(uid, def.id, direction, movedInsts)
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
            widgetId: modelData.widgetId
            uid: modelData.id
            xPos: modelData.xPos
            yPos: modelData.yPos
            xSpan: modelData.xSpan
            ySpan: modelData.ySpan
            onItemSelected: (item) => grid.selectedItem = item
            onPositionChanged: (item) => console.log(`item ${item.uid} position changed`)
            onPositionUpdateRequested: (item) => attemptArrange(item)

            Loader {
                id: loader
                anchors.fill: parent
                property Component widget: grid.availableWidgets.find(def => def.widgetId === gridItem.widgetInst.widgetId).content
                sourceComponent: widget
            }
        }
    }
}
