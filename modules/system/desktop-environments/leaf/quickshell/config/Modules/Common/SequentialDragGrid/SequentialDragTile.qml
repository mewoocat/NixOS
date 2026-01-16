pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Item {
    id: root 

    required property Item dragGrid // The ancestor grid
    required property Component delegate // The content to render
    required property int index // The current index of this tile within the grid
    required property var modelData

    width: 48
    height: 48
    states: [
        // When dragging, parent the dragged item to the grid instead of it's DropArea
        State {
            when: dragHandler.active
            ParentChange { 
              target: root
              parent: root.dragGrid
            }
        }
    ]

    DragHandler {
      id: dragHandler
      target: root
    }
    // In order for this item to emit drag events, the active state of this attached
    // property needs to be bound to the drag handler.
    Drag.active: dragHandler.active
    Drag.source: root
    Drag.hotSpot: Qt.point(width/2, height/2)

    Item {
        anchors.fill: parent
        children: [
            // Using Qt.binding() to bind the modelData property, otherwise this
            // binding of the children will treat root.modelData as a dependecy of children
            // And recreate the object everytime modelData changes
            root.delegate.createObject(this, { modelData: Qt.binding(() => root.modelData) })
        ]
    }
}
