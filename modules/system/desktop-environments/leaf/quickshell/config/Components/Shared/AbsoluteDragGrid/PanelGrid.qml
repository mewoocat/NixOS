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
    required property list<WidgetDefinition> availableWidgets
    property Logic logic: Logic {}
    property int unitSize: 64
    property int xSize: 4
    property int ySize: 8
    property PanelTile selectedItem: null
    property var targetInstance: {
        if (!selectedItem) { return null }

        let proposedXPos = Math.round(selectedItem.x / unitSize)
        let maxXPos = xSize - selectedItem.xSpan
        if (proposedXPos > maxXPos) { proposedXPos = maxXPos }
        if (proposedXPos < 0) { proposedXPos = 0 }

        let proposedYPos = Math.round(selectedItem.y / unitSize)
        let maxYPos = ySize - selectedItem.ySpan
        if (proposedYPos > maxYPos) { proposedYPos = maxYPos }
        if (proposedYPos < 0) { proposedXPos = 0 }

        return root.logic.generateWidgetInst(
            selectedItem.widgetId,
            proposedXPos, proposedYPos,
            selectedItem.xSpan, selectedItem.ySpan,
            selectedItem.uid
        )
    }

    width: unitSize * xSize
    height: unitSize * ySize
    color: "black"

    Item {
        id: targetGhost
        x: root.targetInstance == null ? 0 : root.targetInstance.xPos * root.unitSize
        y: root.targetInstance == null ? 0 : root.targetInstance.yPos * root.unitSize
        visible: root.selectedItem != null
        width: root.selectedItem?.width
        height: root.selectedItem?.height
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
            property WidgetInstance widgetInstance: modelData
            property WidgetDefinition widgetDefinition: root.logic.GetWidgetDefinition(widgetInstance.widgetDefinitionId)
            widgetId: widgetInstance.uid
            uid: widgetInstance.uid
            xPos: widgetInstance.xPosition
            yPos: widgetInstance.yPosition
            xSpan: widgetInstance.xSize
            ySpan: widgetInstance.ySize
            unitSize: root.unitSize
            onItemSelected: (item) => root.selectedItem = item

            Loader {
                id: loader
                anchors.fill: parent
                sourceComponent: parent.widgetDefinition.component
            }
        }
    }
}
