pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

MouseArea {
    id: root

    required property WidgetInstance widgetInstance
    required property WidgetDefinition widgetDefinition
    required property PanelGrid panelGrid

    property int initialX: 0
    property int initialY: 0

    signal itemSelected(item: PanelTile)
    signal positionUpdateRequested(item: PanelTile)

    onXChanged: widgetPositionChanged(root)
    onYChanged: widgetPositionChanged(root)

    x: widgetInstance.xPos * unitSize
    y: widgetInstance.yPos * unitSize

    // apparently need to use implicit sizes if this component is going to be used 
    // in a BoundComponent.  Otherwise the size is forced to the BoundComponent's size
    implicitWidth: xSpan * unitSize
    implicitHeight: ySpan * unitSize

    drag.target: root
    // Moves the client to the top compared to it's sibling clients
    drag.onActiveChanged: () => drag.active ? root.z = 1 : root.z = 0
    onPressed: {
        // Store original position
        initialX = root.x
        initialY = root.y
        itemSelected(root) // emit signal
    }
    onReleased: {
        positionUpdateRequested(root)
    }

    Rectangle {
        anchors.fill: parent
        color: "pink"
    }
}
