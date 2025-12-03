pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

MouseArea {
    id: gridItem
    signal positionUpdateRequested(item: GridItem)
    signal positionChanged(item: GridItem)
    signal itemSelected(item: GridItem)
    //signal modelUpdated(newModel: list<var>)
    //required property GridArea parentGrid // the grid parent
    //required property var gridItemDef // persisted JSON representing the item props

    required property string widgetId
    required property string uid
    required property int xSpan
    required property int ySpan

    // These are just defaults and must be overwritten when this GridItem is instantiated
    property int unitSize: 64
    property int xPos: 0
    property int yPos: 0

    property int initialX: 0
    property int initialY: 0

    onXChanged: positionChanged(gridItem)
    onYChanged: positionChanged(gridItem)

    // Position & Size
    x: xPos * unitSize
    y: yPos * unitSize
    // apparently need to use implicit sizes if this component is going to be used 
    // in a BoundComponent.  Otherwise the size if forced to the BoundComponent's size
    implicitWidth: xSpan * unitSize
    implicitHeight: ySpan * unitSize

    drag.target: gridItem
    // Moves the client to the top compared to it's sibling clients
    drag.onActiveChanged: () => drag.active ? gridItem.z = 1 : gridItem.z = 0
    onPressed: {
        // Store original position
        initialX = gridItem.x
        initialY = gridItem.y
        itemSelected(gridItem) // emit signal
    }
    onReleased: {
        positionUpdateRequested(gridItem)
    }

    Rectangle {
        anchors.fill: parent
        color: "pink"
    }
}
