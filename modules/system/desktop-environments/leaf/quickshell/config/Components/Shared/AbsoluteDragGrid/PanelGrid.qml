pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import QtQuick.Layouts
import qs as Root
import qs.Components.Controls as Ctrls

ColumnLayout {
    id: root
    property list<var> model: [] // Expects a list of WidgetInstances
    property Logic logic: Logic {}
    property int unitSize: 72
    property int widgetPadding: Root.State.mediumSpace
    property int widgetRadius: Root.State.innerRounding
    property int xSize: 4
    property int ySize: 8
    property bool allowEditToggle: true
    property bool editable: false
    property PanelTile selectedTile: null
    property int maxHeight: gridPanel.height// + editPanel.expandedHeight
    property int selectedTileTargetX: {
        if (!selectedTile) { return 0 }

        let proposedXPos = Math.round(selectedTile.x / unitSize)
        let maxXPos = xSize - selectedTile.widgetData.xSize
        if (proposedXPos > maxXPos) { proposedXPos = maxXPos }
        if (proposedXPos < 0) { proposedXPos = 0 }
        return proposedXPos
    }
    property int selectedTileTargetY: {
        if (!selectedTile) { return 0 }

        let proposedYPos = Math.round(selectedTile.y / unitSize)
        let maxYPos = ySize - selectedTile.widgetData.ySize
        if (proposedYPos > maxYPos) { proposedYPos = maxYPos }
        if (proposedYPos < 0) { proposedYPos = 0 }
        return proposedYPos
    }

    signal modelUpdated(model: list<var>) // When a new model state has been confirmed
    //signal widgetJsonUpdated(widgetJson: list<var>)

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
            onModelChanged: console.debug(`REPEATER.MODEL CHANGED TO: ${model}`)
            // !! WARNING: Stupid fucking hack
            // This is needed to fix an issue where this model becomes filled with null values on hot reload.
            // The source root.model still seems to be populated correctly.
            // I believe this fixes the issue due to waiting for the old objects of the model to be destroyed 
            // before creating the new ones.
            //Component.onCompleted: model = root.logic.widgetInstanceListToWidgetDataList(root.model, gridPanel)
            model: root.logic.widgetInstanceListToWidgetDataList(root.model, gridPanel) // Causes new objects to get destroyed on hot reload

            delegate: PanelTile {
                id: gridItem
                required property WidgetData modelData
                Component.onCompleted: {
                    console.debug(`root.model: ${root.model}`)
                    console.debug(`repeater.model: ${repeater.model}`)
                    console.debug(`modelData: ${modelData}`)
                }
                widgetData: modelData
                onWidgetDataChanged: console.debug(`WIDGETDATA CHANGED TO: ${widgetData}`)
                editable: root.editable
                padding: root.widgetPadding
                radius: root.widgetRadius
                showBackground: widgetData.showBackground
                unitSize: root.unitSize
                onTileSelected: (item) => root.selectedTile = item
                onPositionUpdateRequested: (item) => {
                    if (!root.logic.isPositionOpen(widgetData, root.selectedTileTargetX, root.selectedTileTargetY, root.model)){
                        resetPosition()
                        root.selectedTile = null
                        return
                    }

                    // Update the item
                    x = root.selectedTileTargetX * root.unitSize
                    y = root.selectedTileTargetY * root.unitSize
                    widgetData.xPosition = root.selectedTileTargetX
                    widgetData.yPosition = root.selectedTileTargetY

                    // Recompute the list of widget instances given the state change
                    const newInstances = root.logic.widgetDataListToWidgetInstanceList(repeater.model)

                    // Notify the source data to update. Since bindings are only one way, if the model
                    // property for this PanelGrid gets re-bound, the original source value won't be updated.
                    // So instead we send the updated model to the consumer and it can then update the 
                    // source data.  The model is then implicitly updated due to it's continued binding
                    // with the source source data.
                    root.modelUpdated(newInstances)
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
    // TODO: Move to seperate component
    /*
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
    */
}
