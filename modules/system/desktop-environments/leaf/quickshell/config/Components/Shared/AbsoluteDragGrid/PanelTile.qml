pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Components.Widgets
import qs as Root

Rectangle {
    id: root

    required property WidgetData widgetData
    required property PanelGrid panelGrid

    property int unitSize: panelGrid.unitSize
    property bool editable: panelGrid.editable
    property bool showBackground: widgetData.showBackground
    property int contentPadding: widgetData.padding
    property int padding: 0
    property int radius: 0
    property int initialX: 0
    property int initialY: 0
    property PanelGrid initialPanelGrid: panelGrid          // Holds the PanelGrid this tile originated from

    signal dragStarted(item: PanelTile)
    signal dropAccepted(item: PanelTile)
    signal dropRejected(item: PanelTile)

    function resetPosition() {
        x = initialX
        y = initialY
    }

    // Wobble animation
    SequentialAnimation on rotation {
        id: wobbleAnimation
        loops: Animation.Infinite
        running: root.editable
        onRunningChanged: { if (!running) root.rotation = 0 }
        RotationAnimation {
            duration: 100
            direction: RotationAnimation.Clockwise
            from: 0
            to: 2
        }
        RotationAnimation {
            duration: 200
            direction: RotationAnimation.Counterclockwise
            from: 2
            to: -2
        }
        RotationAnimation {
            duration: 100
            direction: RotationAnimation.Clockwise
            from: -2
            to: 0
        }
    }

    // apparently need to use implicit sizes if this component is going to be used 
    // in a BoundComponent.  Otherwise the size is forced to the BoundComponent's size
    implicitWidth: widgetData.xSize * unitSize
    implicitHeight: widgetData.ySize * unitSize
    x: widgetData.xPosition * unitSize
    y: widgetData.yPosition * unitSize
    color: "#000000ff"
    Behavior on x { PropertyAnimation { duration: 50; easing.type: Easing.Linear} }
    Behavior on y { PropertyAnimation { duration: 50; easing.type: Easing.Linear} }
    // Send drag events so that a DropArea can detect this item when dragged
    Drag.active: mouseArea.drag.active

    Rectangle {
        color: Root.State.colors.surface_container
        radius: root.radius
        x: root.padding
        y: root.padding
        width: parent.width - root.padding * 2
        height: parent.height - root.padding * 2
        Loader {
            x: root.contentPadding
            y: root.contentPadding
            width: parent.width - root.contentPadding * 2
            height: parent.height - root.contentPadding * 2
            active: root.widgetData.component != null
            sourceComponent: root.widgetData.component
        }
    }

    // Note that this appears over the content when active
    MouseArea {
        id: mouseArea
        visible: root.editable
        anchors.fill: parent

        Behavior on x { PropertyAnimation { duration: 150; easing.type: Easing.Linear} }
        Behavior on y { PropertyAnimation { duration: 150; easing.type: Easing.Linear} }
        
        drag.target: root
        // Moves the client to the top compared to it's sibling clients
        drag.onActiveChanged: () => drag.active ? root.z = 1 : root.z = 0
        onPressed: {
            // Store original position
            root.initialX = root.x
            root.initialY = root.y
            root.dragStarted(root) // emit signal
        }
        onReleased: {
            print(`${root}: relased with selected x/y ${root.panelGrid.selectedTileTargetX}/${root.panelGrid.selectedTileTargetY}`)
            print(`PanelTile: panelGrid: ${root.panelGrid}`)
            /*
            if (!root.logic.isPositionOpen(widgetData, repeater.model)){
                resetPosition()
                root.selectedTile = null
                root.dropRejected(root)
                return
            }
            */

            // Update the position of the tile relative it's PanelGrid
            root.widgetData.xPosition = root.panelGrid.selectedTileTargetX
            root.widgetData.yPosition = root.panelGrid.selectedTileTargetY
            root.x = root.widgetData.xPosition * root.unitSize
            root.y = root.widgetData.yPosition * root.unitSize

            root.dropAccepted(root)
        }
    }
}
