pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import QtQuick.Layouts
import qs as Root
import qs.Components.Controls as Ctrls

// TODO: Writing the adapter shouldn't regenerate the widgets
Rectangle {
    id: root
    property list<var> model: [] // Expects a list of WidgetInstances
    property Logic logic: Logic {}
    property int unitSize: 64
    property int widgetPadding: Root.State.widgetPadding
    property int widgetRadius: Root.State.widgetRounding
    property int xSize: 4
    property int ySize: 8
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
    signal tileDropAccepted(item: PanelTile)
    signal tileDropRejected(item: PanelTile)

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

    // TODO: Look into not converting to widget data and instead the panel tile takes in the widget
    // instance and coresponding widget data seperately
    Repeater {
        id: repeater
        // TODO: Look into Variants instead of dynamic obj creation from js https://quickshell.org/docs/v0.1.0/types/Quickshell/Variants
        model: root.logic.widgetInstanceListToWidgetDataList(root.model, root, root.widgetRadius)
        //onModelChanged: console.debug(`model: ${JSON.stringify(root.model,null,4)}`)
        delegate: PanelTile {
            required property WidgetData modelData
            widgetData: modelData
            panelGrid: root
            padding: root.widgetPadding
            radius: root.widgetRadius
            onTileSelected: (item) => root.selectedTile = item
            onDropAccepted: (item) => {
                root.selectedTile = null
                root.tileDropAccepted(item)
            }
            onDropRejected: (item) => {
                root.selectedTile = null
                root.tileDropRejected(item)
            }
        }
    }
}
