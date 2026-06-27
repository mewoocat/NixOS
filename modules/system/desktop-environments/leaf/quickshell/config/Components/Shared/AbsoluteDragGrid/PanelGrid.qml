pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import QtQuick.Layouts
import qs as Root
import qs.Components.Controls as Ctrls

Rectangle {
    id: root
    property list<var> model: [] // Expects a list of WidgetInstances
    property Logic logic: Logic {}
    property int unitSize: 64
    property int widgetPadding: Root.State.widgetPadding
    property int widgetRadius: Root.State.widgetRounding
    property int xSize: 4
    property int ySize: 8
    property bool allowEditToggle: true
    property bool editable: false
    property PanelTile selectedTile: null

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
    signal tileDropAccepted()
    signal tileDropRejected()

    function removeTile() {

    }
    function addTile(widgetInstance) {
        root.model.push(widgetInstance)
    }
    function generateInstances() {
        return root.logic.widgetDataListToWidgetInstanceList(repeater.model)
    }

    implicitWidth: root.unitSize * root.xSize
    implicitHeight: root.unitSize * root.ySize
    color: "transparent"

    Item {
        id: targetGhost
        x: root.selectedTile == null ? 0 : root.selectedTileTargetX * root.unitSize + root.selectedTile.padding
        y: root.selectedTile == null ? 0 : root.selectedTileTargetY * root.unitSize + root.selectedTile.padding
        width: root.selectedTile?.width - root.selectedTile?.padding
        height: root.selectedTile?.height - root.selectedTile?.padding
        visible: false
        property int animationSpeed: 100

        // Hack for ensuring the animations don't play when selectedTile is null
        states: [
            State {
                name: "shown"
                when: root.selectedTile != null
                PropertyChanges {
                    targetGhost {
                        visible: true
                    }
                }
            }
        ]
        transitions: [
            Transition {
                to: "shown"
                reversible: true
                SequentialAnimation {
                    PauseAnimation { duration: targetGhost.animationSpeed }
                    PropertyAction {
                        target: targetGhost
                        property: "visible"
                    }
                }
            }
        ]

        Behavior on x { PropertyAnimation { 
            duration: targetGhost.animationSpeed
            easing.type: Easing.Linear
        } }
        Behavior on y { PropertyAnimation {
            duration: targetGhost.animationSpeed
            easing.type: Easing.Linear
        } }

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
        // TODO: Look into Variants instead of dynamic obj creation from js https://quickshell.org/docs/v0.1.0/types/Quickshell/Variants
        model: root.logic.widgetInstanceListToWidgetDataList(root.model, root, root.widgetRadius)
        delegate: PanelTile {
            id: gridItem
            required property WidgetData modelData
            widgetData: modelData
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
                    root.tileDropRejected()
                    return
                }

                // WARNING: THIS DOESN't WORK
                // If this panel grid no longer owns the selected tile, eject it from the model.
                // Something else has taken ownership of it (hopefully).
                /*
                if (!root.selectedTile) {
                    console.debug("pre: " + JSON.stringify(root.model,null,4))
                    root.model.splice(root.model.indexOf(gridItem.widgetData),1)
                    console.debug("post: " + JSON.stringify(root.model,null,4))
                    root.modelUpdated(repeater.model)
                    return
                }
                */

                // Update the item (Not needed if regenerating the whole model?)
                //x = root.selectedTileTargetX * root.unitSize
                //y = root.selectedTileTargetY * root.unitSize

                /*
                // Update the data obj
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

                // TODO: Look into whether setting the selected tile to null after setting 
                // the x/y of this item results in the target ghost glitch
                root.selectedTile = null
                */

                // Notify consumer of dropped tile
                root.tileDropAccepted()
            }
        }
    }
}
