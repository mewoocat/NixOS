pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs as Root
import qs.Components.Controls as Ctrls
import qs.Components.Shared as Shared

ColumnLayout {
    id: root
    required property list<WidgetInstance> model
    required property list<WidgetDefinition> availableWidgetDefinitions
    signal modelUpdated(model: list<WidgetInstance>) // When a new model state has been confirmed
    property Logic logic: Logic {}
    property int unitSize: 72
    property int widgetPadding: 8
    property int widgetMargin: 8
    property int xSize: 4
    property int ySize: 8
    property bool allowEditToggle: true
    property bool editable: false
    property PanelTile selectedTile: null
    property int maxHeight: gridPanel.height + editPanel.expandedHeight
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
        id: gridPanel
        implicitWidth: root.unitSize * root.xSize
        implicitHeight: root.unitSize * root.ySize
        color: "transparent"

        Item {
            id: targetGhost
            x: root.selectedTile == null ? 0 : root.selectedTileTargetX * root.unitSize + root.selectedTile.padding
            y: root.selectedTile == null ? 0 : root.selectedTileTargetY * root.unitSize + root.selectedTile.padding
            Behavior on x { PropertyAnimation { duration: 50; easing.type: Easing.Linear} }
            Behavior on y { PropertyAnimation { duration: 50; easing.type: Easing.Linear} }
            visible: root.selectedTile != null
            Behavior on visible { PropertyAnimation { duration: 50; easing.type: Easing.Linear; from: 0} }
            width: root.selectedTile?.width - root.selectedTile?.padding
            height: root.selectedTile?.height - root.selectedTile?.padding
            Rectangle {
                color: Root.State.colors.on_surface
                opacity: 0.4
                anchors.fill: parent
                anchors.margins: 4
                radius: Root.State.innerRounding
            }
        }

        Repeater {
            id: repeater
            model: root.model
            delegate: PanelTile {
                id: gridItem
                required property WidgetInstance modelData
                editable: root.editable
                widgetInstance: modelData
                widgetDefinition: {
                    if (widgetInstance.widgetDefinition) { return widgetInstance.widgetDefinition }
                    return root.logic.getWidgetDefinition(widgetInstance.widgetDefinitionId, root.availableWidgetDefinitions)
                }
                unitSize: root.unitSize
                onTileSelected: (item) => root.selectedTile = item
                onPositionUpdateRequested: (item) => {
                    if (!root.logic.isPositionOpen(widgetInstance, root.selectedTileTargetX, root.selectedTileTargetY, root.model)){
                        //console.debug(`valid position NOT found`)
                        resetPosition()
                        root.selectedTile = null
                        return
                    }
                    //console.debug(`valid position found`)
                    // Update the instance
                    widgetInstance.xPosition = root.selectedTileTargetX
                    widgetInstance.yPosition = root.selectedTileTargetY
                    // Update the item
                    x = widgetInstance.xPosition * root.unitSize
                    y = widgetInstance.yPosition * root.unitSize

                    // Notify the source model to update.  This is needed since we're modifying a property 
                    // of an object in the model, so no actual change occurs from the perspective of the binding.
                    root.modelUpdated(root.model)
                    root.selectedTile = null
                }
            }
        }

        Ctrls.Button {
            visible: root.allowEditToggle
            anchors.right: parent.right
            anchors.top: parent.top
            id: editButton
            text: "edit"
            onClicked: root.editable = !root.editable
        }

    }
    Rectangle {
        id: editPanel
        visible: root.allowEditToggle
        property int expandedHeight: 300
        Layout.preferredHeight: root.editable ? expandedHeight : 0
        Behavior on Layout.preferredHeight { PropertyAnimation { duration: 500; easing.type: Easing.Linear} }
        Layout.fillWidth: true
        color: "red"
        clip: true
        Shared.ScrollableList {
            anchors.fill: parent
            model: root.availableWidgetDefinitions
            delegate: PanelTile {
                required property WidgetDefinition modelData
                widgetDefinition: modelData
                widgetInstance: root.logic.generateWidgetInstance(root.model, 0, 0)
                editable: true
                unitSize: root.unitSize
            }
        }
    }
}
