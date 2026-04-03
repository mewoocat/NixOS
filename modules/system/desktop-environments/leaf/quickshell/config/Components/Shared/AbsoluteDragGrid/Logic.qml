import QtQml

QtObject {
    function generateWidgetInstance(widgetDefinition: WidgetDefinition, xPosition: int, yPosition: int, uid = null): var {
        if (!uid) {
            uid = Math.random().toString().substr(2) // Generate random string if none provided (probably unique)
        }
        // Apparently need to provide the full relative path, doesn't seem to inherit imported paths
        let component = Qt.createComponent(`WidgetInstance.qml`)
        let widgetInstance = component.createObject(null, {
            uid: uid,
            widgetDefinitionId: widgetDefinition.uid,
            xPosition: xPosition,
            yPosition: yPosition,
            xSize: widgetDefinition.xSize,
            ySize: widgetDefinition.ySize,
            state: widgetDefinition.defaultState,
        })
    }

    function getWidgetDefinition(widgetDefinitionId: string, widgetDefinitions: list<WidgetDefinition>): WidgetDefinition {
        return widgetDefinitions.find(def => {
            return def.uid === widgetDefinitionId
        })
    }
    
    function isPositionOpen(widgetInstance: WidgetInstance, targetXPosition: int, targetYPosition: int, widgetInstances: list<WidgetInstance>): bool {
        for (const otherInst of widgetInstances) {
            console.debug(`comparing with ${otherInst.uid}`)
            if (otherInst.uid === widgetInstance.uid) { continue } // Ignore self
            if (doRectanglesOverlap(
                Qt.point(targetXPosition, targetYPosition),
                Qt.point(targetXPosition + widgetInstance.xSize, targetYPosition + widgetInstance.ySize),
                Qt.point(otherInst.xPosition, otherInst.yPosition),
                Qt.point(otherInst.xPosition + otherInst.xSize, otherInst.yPosition + otherInst.ySize)
            )) {
                return false
            }
        }
        return true
    }

    // Determines whether two rectangles overlap given both of their top left most and bottom 
    // right most points.  This assumes x+ is right and y+ is down. Will return true if top left
    // point of B is less than the bottom right point of B and the bottom right point of B is 
    // greater than the top level point of A.
    function doRectanglesOverlap(A1, A2, B1, B2): bool {
        //console.log(`[CHECKING] for overlap for points\nA1: ${A1.x},${A1.y}\nA2: ${A2.x},${A2.y}\nB1: ${B1.x},${B1.y}\nB2: ${B2.x},${B2.y}`)
        if (
            A1.x < B2.x &&
            A1.y < B2.y && 
            A2.x > B1.x &&
            A2.y > B1.y
        ) {
            return true
        }
        return false
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

}
