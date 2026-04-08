pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs as Root
import qs.Components.Controls as Ctrls

ColumnLayout {
    id: root
    property list<var> widgetJson: [] // Persisted json form of widget instances
    property list<WidgetData> model: logic.widgetJsonListToWidgetDataList(widgetJson)
    signal modelUpdated(model: list<WidgetData>) // When a new model state has been confirmed
    signal widgetJsonUpdated(widgetJson: list<var>)
    property Logic logic: Logic {}
    property int unitSize: 72
    property int widgetPadding: Root.State.mediumSpace
    //property int widgetMargin: 8
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
                required property WidgetData modelData
                widgetData: modelData
                // For each WidgetData used to create a PanelTile, load it's ancestor PanelGrid into it.
                // This is useful when a widget component needs to know the geometry of it's PanelGrid
                Component.onCompleted: widgetData.panelGrid = gridPanel
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

                    // Update the json
                    const newJson = root.logic.widgetDataListToWidgetJsonList(root.model)

                    // Notify the source data to update. Since bindings are only one way, if the widgetJson
                    // property for this PanelGrid gets re-bound, the original source value won't be updated.
                    // So instead we send the updated jsonWidgets to the consumer and it can then update the 
                    // source data.  The widgetJson is then implicitly updated due to it's continued binding
                    // with the source source data.
                    root.widgetJsonUpdated(newJson)
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
