pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs as Root
import qs.Components.Controls as Ctrls

ColumnLayout {
    id: root
    required property list<WidgetInstance> model
    required property list<WidgetDefinition> availableWidgetDefinitions
    signal modelUpdated(model: list<WidgetInstance>) // When a new model state has been confirmed
    property Logic logic: Logic {}
    property int unitSize: 64
    property int widgetPadding: 8
    property int widgetMargin: 8
    property int xSize: 4
    property int ySize: 8
    property bool editable: false
    property PanelTile selectedTile: null
    property int selectedTileTargetX: {
        if (!selectedTile) { return 0 }

        let proposedXPos = Math.round(selectedTile.x / unitSize)
        let maxXPos = xSize - selectedTile.widgetDefinition.xSize
        if (proposedXPos > maxXPos) { proposedXPos = maxXPos }
        if (proposedXPos < 0) { proposedXPos = 0 }
        return proposedXPos
    }
    property int selectedTileTargetY: {
        if (!selectedTile) { return 0 }

        let proposedYPos = Math.round(selectedTile.y / unitSize)
        let maxYPos = ySize - selectedTile.widgetDefinition.ySize
        if (proposedYPos > maxYPos) { proposedYPos = maxYPos }
        if (proposedYPos < 0) { proposedYPos = 0 }
        return proposedYPos
    }

    Rectangle {

        implicitWidth: root.unitSize * root.xSize
        implicitHeight: root.unitSize * root.ySize
        color: "green"

        Item {
            id: targetGhost
            x: root.selectedTile == null ? 0 : root.selectedTileTargetX * root.unitSize
            y: root.selectedTile == null ? 0 : root.selectedTileTargetY * root.unitSize
            Behavior on x { PropertyAnimation { duration: 50; easing.type: Easing.Linear} }
            Behavior on y { PropertyAnimation { duration: 50; easing.type: Easing.Linear} }
            visible: root.selectedTile != null
            width: root.selectedTile?.width
            height: root.selectedTile?.height
            Rectangle {
                color: Root.State.colors.on_surface
                opacity: 0.4
                anchors.fill: parent
                anchors.margins: 4
                radius: Root.State.rounding
            }
        }

        Repeater {
            id: repeater
            model: root.model
            Component.onCompleted: {
                root.availableWidgetDefinitions.forEach(v => {
                    console.debug("WidDef: " + v.uid)
                })
            }
            delegate: PanelTile {
                id: gridItem
                required property WidgetInstance modelData
                editable: root.editable
                widgetInstance: modelData
                widgetDefinition: {
                    let def = root.logic.getWidgetDefinition(widgetInstance.widgetDefinitionId, root.availableWidgetDefinitions)
                    def.unitSize = root.unitSize
                    def.padding = root.widgetPadding
                    return def
                }
                Component.onCompleted: console.debug(`panel tile: ${widgetDefinition.uid}`)
                unitSize: root.unitSize
                onTileSelected: (item) => root.selectedTile = item
                onPositionUpdateRequested: (item) => {
                    if (!root.logic.isPositionOpen(widgetInstance, root.selectedTileTargetX, root.selectedTileTargetY, root.model)){
                        console.debug(`valid position NOT found`)
                        resetPosition()
                        return
                    }
                    console.debug(`valid position found`)
                    // Update the instance
                    widgetInstance.xPosition = root.selectedTileTargetX
                    widgetInstance.yPosition = root.selectedTileTargetY
                    // Update the item
                    x = widgetInstance.xPosition * root.unitSize
                    y = widgetInstance.yPosition * root.unitSize

                    // Notify the source model to update.  This is needed since we're modifying a property 
                    // of an object in the model, so no actual change occurs from the perspective of the binding.
                    root.modelUpdated(root.model)
                }
            }
        }

        Ctrls.Button {
            anchors.right: parent.right
            anchors.top: parent.top
            id: editButton
            text: "edit"
            onClicked: root.editable = !root.editable
        }

    }
    Rectangle {
        id: editPanel
        //visible: root.editable
        Layout.preferredHeight: root.editable ? 300 : 0
        Behavior on Layout.preferredHeight { PropertyAnimation { duration: 500; easing.type: Easing.Linear} }
        Layout.fillWidth: true
        color: "red"
    }
}
