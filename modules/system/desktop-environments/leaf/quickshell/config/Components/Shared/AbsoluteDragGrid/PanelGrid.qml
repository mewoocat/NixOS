pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root
    signal modelUpdated(model: list<var>) // When a new model state has been confirmed
    signal modelInvalid(model: list<var>) // When the model needs to be reset
    required property list<WidgetInstance> model
    property Logic logic: Logic {}
    property int unitSize: 64
    property int xSize: 4
    property int ySize: 8
    property PanelTile selectedTile: null
    property int selectedTileTargetX: {
        if (!selectedTile) { return 0 }

        let proposedXPos = Math.round(selectedTile.x / unitSize)
        let maxXPos = xSize - selectedTile.xSize
        if (proposedXPos > maxXPos) { proposedXPos = maxXPos }
        if (proposedXPos < 0) { proposedXPos = 0 }
        return proposedXPos
    }
    property int selectedTileTargetY: {
        if (!selectedTile) { return 0 }

        let proposedYPos = Math.round(selectedTile.y / unitSize)
        let maxYPos = ySize - selectedTile.ySpan
        if (proposedYPos > maxYPos) { proposedYPos = maxYPos }
        if (proposedYPos < 0) { proposedXPos = 0 }
        return proposedYPos
    }

    width: unitSize * xSize
    height: unitSize * ySize
    color: "black"

    Item {
        id: targetGhost
        x: root.selectedTile == null ? 0 : root.selectedTileTargetX * root.unitSize
        y: root.selectedTile == null ? 0 : root.selectedTileTargetY * root.unitSize
        visible: root.selectedTile != null
        width: root.selectedTile?.width
        height: root.selectedTile?.height
        Rectangle {
            color: "white"
            anchors.fill: parent
            anchors.margins: 8
        }
    }

    Repeater {
        id: repeater
        model: root.model
        delegate: PanelTile {
            id: gridItem
            required property WidgetInstance modelData
            widgetInstance: modelData
            unitSize: root.unitSize
            onTileSelected: (item) => root.selectedTile = item
            onPositionUpdateRequested: (item) => {
                if (!root.logic.isPositionOpen(widgetInstance, root.selectedTileTargetX, root.selectedTileTargetY, root.model)){
                    console.debug(`valid position NOT found`)
                    // Reset the position
                    x = initialX
                    y = initialY
                    return
                }
                console.debug(`valid position found`)
                // Update the instance
                widgetInstance.xPosition = root.selectedTileTargetX
                widgetInstance.yPosition = root.selectedTileTargetY
                // Update the item
                x = widgetInstance.xPosition * root.unitSize
                y = widgetInstance.yPosition * root.unitSize
            }
        }
    }
}
