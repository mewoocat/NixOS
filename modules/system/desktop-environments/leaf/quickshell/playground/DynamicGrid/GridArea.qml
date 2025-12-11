pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: grid
    signal modelUpdated(model: list<var>) // When a new model state has been confirmed
    signal modelInvalid(model: list<var>) // When the model needs to be reset
    required property list<var> model
    required property list<WidgetDef> availableWidgets

    property int unitSize: 64
    property int xSize: 4
    property int ySize: 8
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
            selectedItem.xSpan, selectedItem.ySpan,
            selectedItem.uid
        )
    }

    width: unitSize * xSize
    height: unitSize * ySize

    color: "black"

    function generateWidgetInst(widgetId: string, xPos: int, yPos: int, xSpan: int, ySpan: int, uid = null): var {
        if (!uid) {
            console.log(`generateWidgetInst: uid was not provided ... generating one`)
            uid = Math.random().toString().substr(2) // Generate random string if none provided (probably unique)
        }
        return {
            uid: uid,
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

        const inst = findSpot(widgetDef)
        if (!inst) { console.error(`Could not add widget: ${widgetId}.  No valid spot exists`); return }

        grid.model.push(inst)
        grid.modelUpdated(grid.model)
    }

    // Returns the first valid spot for a widget definition.
    // Returns a new instance for it or null if no valid spot exists
    function findSpot(def: WidgetDef): var {
        // Generate proposed instance for the provided definition
        const proposedInst = generateWidgetInst(def.widgetId, 0, 0, def.xSpan, def.ySpan)
        // Iterate over each possible spot
        for (let yPos = 0; yPos <= ySize - def.ySpan; yPos++) {
            for (let xPos = 0; xPos <= xSize - def.xSpan; xPos++) {
                // Test if the proposed position is valid
                proposedInst.xPos = xPos
                proposedInst.yPos = yPos
                if (!isPositionOverlapping(proposedInst)) {
                    return proposedInst
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
        console.log(`getIntersectingInsts | grid.model: ${JSON.stringify(grid.model, null, 4)}`)
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
            inst.xPos + inst.xSpan < grid.xSize &&
            inst.yPos >= 0 &&
            inst.yPos + inst.yPos < grid.ySize;
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

    // Returns the midpoint of the provided item relative to its parent
    function getItemMidpoint(item: Item): var {
        return {
            x: (item.x + (item.x + item.width)) / 2,
            y: (item.y + (item.y + item.height)) / 2
        }
    }

    // Given a GridItem, get the instance object
    function getInstForGridItem(item: GridItem): var {
        return generateWidgetInst(item.widgetId, item.xPos, item.yPos, item.xSpan, item.ySpan, item.uid)
    }

    // Given a widget instance uid, get the instance data
    function getWidgetInst(uid: string): var {
        const widgetInst = grid.model.find(inst => {
            return inst.uid === uid
        })
        return widgetInst
    }

    function getWidgetItem(uid: string): Item {
        const item = grid.children.find(i => i.uid === uid)
        return item
    }

    //
    function moveWidget(item: GridItem, xPos: int, yPos: int) {
        const inst = getWidgetInst(item.uid)

        // Snap the item to the proposed position
        item.x = xPos * grid.unitSize
        item.y = yPos * grid.unitSize

        // Update the widget instance in the model
        inst.xPos = xPos
        inst.yPos = yPos

        // Trigger updated signal
        //grid.modelUpdated(grid.model)
    }

    //
    function recursiveRearrange(moveeInst: var, collideeInst: var, movedDirection: var, movedInsts: var): bool {

        let proposedX = collideeInst.xPos + movedDirection.x
        let proposedY = collideeInst.yPos + movedDirection.y

        // Move the collidee in the provided direction until it no longer collides with the movee or hits a grid boundary
        let intersection = true
        console.log(`intesection exists`)
        while (intersection) {
            intersection = doRectanglesOverlap(
                Qt.point(moveeInst.xPos, moveeInst.yPos),
                Qt.point(moveeInst.xPos + moveeInst.xSpan, moveeInst.yPos + moveeInst.ySpan),
                Qt.point(proposedX, proposedY),
                Qt.point(collideeInst.xPos + collideeInst.xSpan, collideeInst.yPos + collideeInst.ySpan)
            )
            let inBounds = isPositionInBounds(collideeInst, proposedX, proposedY)
            if (!inBounds) {
                console.log(`reached out of bounds ... no possible position`)
                return false; // Base condition
            }
            if (!intersection) {
                console.log(`no longer intesecting ... found position for collidee thats in bounds`)

                // NOTE: the collideeInst here is a ref to the actual inst in the model ... changing the x/y pos here 
                // moves the item in the grid
                collideeInst.xPos = proposedX;
                collideeInst.yPos = proposedY;

                movedInsts.push(collideeInst)
                return true; // Base condition
            }

            // Try another space over in the move direction
            proposedX += movedDirection.x
            proposedY += movedDirection.y
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
        
        //const itemInst = getInstForGridItem(item)
        const intersectingInsts = getIntersectingInsts(targetInst)
        console.log("intersectingInsts: " + JSON.stringify(intersectingInsts, null, 4))

        // If no overlap then no rearrangement needs to occur
        const noOverlap = intersectingInsts.length == 0
        if (noOverlap) {
            console.log(`no overlap occured`)
            moveWidget(item, targetInst.xPos, targetInst.yPos)
            grid.selectedItem = null
            grid.modelUpdated(grid.model)
            return
        }

        // Add the proposed move to the stack
        movedInsts.push(targetInst)

        // Find midpoint of moved item relative to grid
        const movedMidpoint = getItemMidpoint(item)
        console.log(`movedMidpoint: ${JSON.stringify(movedMidpoint, null, 4)}`)

        // Need to move all intersecting widgets out of the way
        intersectingInsts.forEach(intersectingInst => {
            console.log(`intersecting inst: ${JSON.stringify(intersectingInst, null, 4)}`)
            const intersectingItem = getWidgetItem(intersectingInst.uid)

            // find midpoint of intersecting item relative to grid
            const intersectingMidPoint = getItemMidpoint(intersectingItem)
            console.log(`intersectingMidpoint: ${JSON.stringify(intersectingMidPoint, null, 4)}`)

            // find which x and y side of the intersecting item the midpoint is closest to
            const xDirection = movedMidpoint.x < intersectingMidPoint.x ? -1 : 1
            const yDirection = movedMidpoint.y < intersectingMidPoint.y ? -1 : 1
            console.log(`xDir: ${xDirection} | yDir ${yDirection}`)

            // find the distance diff (delta) between the x and y direction
            const xDelta = Math.abs(movedMidpoint.x - intersectingMidPoint.x)
            const yDelta = Math.abs(movedMidpoint.y - intersectingMidPoint.y)
            console.log(`xDelta: ${xDelta} | yDelta: ${yDelta}`)

            // Determine direction to move the intersecting item
            let direction
            // Search for an open position for this intersecting item in the x or y direction
            if (xDelta > yDelta) {
                direction = {x: -xDirection, y: 0}
            }
            else {
                direction = {x: 0, y: -yDirection}
            }
            console.log(`direction is ${direction.x}, ${direction.y}`)

            // Move the intersecting item till it no longer collides with the original moved item
            recursiveRearrange(targetInst, intersectingInst, direction, movedInsts)
        })

        // Move failure
        /*
        if (!validMove) {
            x = initialX
            y = initialY
        }
        else {
            // complete the move for the selected widget
            moveWidget(gridItem.uid, selectedTargetColumn, selectedTargetRow)
        }
        */

        // Trigger updated signal
        grid.modelUpdated(grid.model)
        grid.selectedItem = null
    }

    Item {
        id: targetGhost
        x: grid.targetInst == null ? 0 : grid.targetInst.xPos * grid.unitSize
        y: grid.targetInst == null ? 0 : grid.targetInst.yPos * grid.unitSize
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
            widgetId: modelData.widgetId
            uid: {
                console.log(`uid: ${modelData.uid}`)
                return modelData.uid
            }
            xPos: modelData.xPos
            yPos: modelData.yPos
            xSpan: modelData.xSpan
            ySpan: modelData.ySpan
            unitSize: grid.unitSize
            onItemSelected: (item) => grid.selectedItem = item
            //onWidgetPositionChanged: (item) => console.log(`item ${item} position changed`)
            onPositionUpdateRequested: (item) => attemptArrange(item)

            Loader {
                id: loader
                anchors.fill: parent
                property Component widget: grid.availableWidgets.find(def => def.widgetId === gridItem.widgetId).content
                sourceComponent: widget
            }
        }
    }
}
