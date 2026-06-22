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
    property int unitSize: 64
    property int widgetPadding: Root.State.widgetPadding
    property int widgetRadius: Root.State.widgetRounding
    property int xSize: 4
    property int ySize: 8
    property bool allowEditToggle: true
    property bool editable: false
    property PanelTile selectedTile: null
    // Doesn't seem to stop the animation from running
    onSelectedTileChanged: {
        if (selectedTile == null) {
            ghostXAnim.stop()
            ghostYAnim.stop()
            ghostVisibleAnim.stop()
        }
    }
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

    Rectangle {
        id: gridPanel
        implicitWidth: root.unitSize * root.xSize
        implicitHeight: root.unitSize * root.ySize
        color: "transparent"

        Item {
            id: targetGhost
            x: root.selectedTile == null ? -1000 : root.selectedTileTargetX * root.unitSize + root.selectedTile.padding
            y: root.selectedTile == null ? -1000 : root.selectedTileTargetY * root.unitSize + root.selectedTile.padding
            width: root.selectedTile?.width - root.selectedTile?.padding
            height: root.selectedTile?.height - root.selectedTile?.padding
            //visible: root.selectedTile != null

            property bool animationsRunning: false

            // Hack for ensuring the animations don't play when selectedTile is null
            /*
            Timer {
                id: animationStartTimer
                interval: 1000
                running: false
                onTriggered: animationsRunning = true
            }
            Timer {
                id: animationStopTimer
                interval: 100
                running: false
                onTriggered: animationsRunning = false
            }
            Connections {
                target: root
                function onSelectedTileChanged() {
                    if (selectedTile != null) animationStartTimer.start()
                }
            }
            */

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
                    PauseAnimation { duration: 1000 }
                    PropertyAction {
                        target: targetGhost
                        property: "visible"
                        value: true
                    }
                }
            ]

            // These animations are causing the ghost glitch
            Behavior on x { PropertyAnimation { 
                id: ghostXAnim
                //alwaysRunToEnd: false
                running: targetGhost.animationsRunning
                //running: root.selectedTile != null
                //paused: root.selectedTile != null
                duration: 50
                easing.type: Easing.Linear
            } }
            Behavior on y { PropertyAnimation {
                id: ghostYAnim
                //alwaysRunToEnd: false
                running: targetGhost.animationsRunning
                //paused: root.selectedTile != null
                duration: 50
                easing.type: Easing.Linear
            } }
            /*
            Behavior on visible { PropertyAnimation {
                id: ghostVisibleAnim
                alwaysRunToEnd: false
                running: targetGhost.animationsRunning
                //running: root.selectedTile != null
                //paused: root.selectedTile != null
                duration: 50
                easing.type: Easing.Linear;
                from: 0
            } }
            */

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
            model: root.logic.widgetInstanceListToWidgetDataList(root.model, gridPanel, root.widgetRadius)
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
    }
}
