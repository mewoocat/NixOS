pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Components.Widgets
import qs as Root

Item {
    id: root

    required property WidgetData widgetData
    required property int unitSize

    property bool editable: false
    property int padding: 0
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

    // apparently need to use implicit sizes if this component is going to be used 
    // in a BoundComponent.  Otherwise the size is forced to the BoundComponent's size
    implicitWidth: widgetData.xSize * unitSize
    implicitHeight: widgetData.ySize * unitSize
    x: widgetData.xPosition * unitSize
    y: widgetData.yPosition * unitSize
    Behavior on x { PropertyAnimation { duration: 50; easing.type: Easing.Linear} }
    Behavior on y { PropertyAnimation { duration: 50; easing.type: Easing.Linear} }
    

    Rectangle {
        x: root.padding
        y: root.padding
        width: parent.width - root.padding * 2
        height: parent.height - root.padding * 2
        color: root.showBackground ? Root.State.colors.surface_container : "transparent"
        radius: root.radius
        Loader {
            anchors.fill: parent
            sourceComponent: root.widgetData.component
        }
    }
    // Note that this appears over the content when active
    MouseArea {
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
