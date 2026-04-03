pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

MouseArea {
    id: root

    required property WidgetInstance widgetInstance
    required property int unitSize

    property int initialX: 0
    property int initialY: 0

    signal tileSelected(item: PanelTile)
    signal positionUpdateRequested(item: PanelTile)
    signal widgetPositionChanged(item: PanelTile)

    x: widgetInstance.xPosition * unitSize
    y: widgetInstance.yPosition * unitSize
    onXChanged: widgetPositionChanged(root)
    onYChanged: widgetPositionChanged(root)

    // apparently need to use implicit sizes if this component is going to be used 
    // in a BoundComponent.  Otherwise the size is forced to the BoundComponent's size
    implicitWidth: widgetInstance.xSize * unitSize
    implicitHeight: widgetInstance.ySize * unitSize

    drag.target: root
    // Moves the client to the top compared to it's sibling clients
    drag.onActiveChanged: () => drag.active ? root.z = 1 : root.z = 0
    onPressed: {
        // Store original position
        initialX = root.x
        initialY = root.y
        tileSelected(root) // emit signal
    }
    onReleased: {
        positionUpdateRequested(root)
    }

    Rectangle {
        anchors.fill: parent
        color: "red"
        /*
        Loader {
            anchors.fill: parent
            sourceComponent: root.widgetInstance.component
        }
        */
    }
}
