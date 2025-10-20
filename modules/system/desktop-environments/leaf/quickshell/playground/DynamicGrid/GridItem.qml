pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

MouseArea {
    id: gridItem
    signal positionUpdateRequested(item: GridItem)
    signal itemSelected(item: GridItem)
    //signal modelUpdated(newModel: list<var>)
    //required property GridArea parentGrid // the grid parent
    //required property var gridItemDef // persisted JSON representing the item props

    required property string widgetId
    required property int cellRowSpan
    required property int cellColumnSpan

    // These are just defaults and must be overwritten when this GridItem is instantiated
    property int unitSize: 64
    property int row: 0
    property int column: 0

    property int initialX: 0
    property int initialY: 0

    // Position & Size
    x: column * unitSize
    y: row * unitSize
    // apparently need to use implicit sizes if this component is going to be used 
    // in a BoundComponent.  Otherwise the size if forced to the BoundComponent's size
    implicitWidth: cellColumnSpan * unitSize
    implicitHeight: cellRowSpan * unitSize

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
