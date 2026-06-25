pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Components.Widgets
import qs as Root

Rectangle {
    id: root
    color: "#000000ff"

    required property WidgetData widgetData
    required property int unitSize

    property bool editable: false
    property int padding: 0
    property int contentPadding: widgetData.padding
    property bool showBackground: true
    property int radius: 0

    signal tileSelected(item: PanelTile)
    signal positionUpdateRequested(item: PanelTile)
    signal widgetPositionChanged(item: PanelTile)

    property int initialX: 0
    property int initialY: 0
    function resetPosition() {
        x = initialX
        y = initialY
    }

    // Send drag events so that a DropArea can detect this item when dragged
    Drag.active: mouseArea.drag.active

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
    Behavior on x { PropertyAnimation { duration: 50; easing.type: Easing.Linear} }
    Behavior on y { PropertyAnimation { duration: 50; easing.type: Easing.Linear} }

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
        onXChanged: root.widgetPositionChanged(root)
        onYChanged: root.widgetPositionChanged(root)

        Behavior on x { PropertyAnimation { duration: 150; easing.type: Easing.Linear} }
        Behavior on y { PropertyAnimation { duration: 150; easing.type: Easing.Linear} }
        
        drag.target: root
        // Moves the client to the top compared to it's sibling clients
        drag.onActiveChanged: () => drag.active ? root.z = 1 : root.z = 0
        onPressed: {
            // Store original position
            root.initialX = root.x
            root.initialY = root.y
            root.tileSelected(root) // emit signal
        }
        onReleased: {
            root.positionUpdateRequested(root)
        }
    }
}
