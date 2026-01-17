pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Item {
    id: root 

    required property Item dragGrid // The ancestor grid
    required property Component delegate // The content to render
    required property int index // The current index of this tile within the source model
    required property int visualIndex // The current index of this tile within the visual model
    required property var modelData

    width: 48
    height: 48
    states: [
        // When dragging, parent the dragged item to the grid instead of it's DropArea
        State {
            when: root.Drag.active
            ParentChange { 
              target: root
              parent: root.dragGrid
            }
        }
    ]

    DragHandler {
        id: dragHandler
        target: root
        // Need to explicitly invoke the drop method so a DropArea can read the drop
        onActiveChanged: {
            if (!active) {
                target.Drag.drop()
            }
        }
    }
    // In order for this item to emit drag events, the active state of this attached
    // property needs to be bound to the drag handler.
    Drag.active: dragHandler.active

    // This doesn't drag if another MouseArea is a child of this
    /*
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        drag.target: root
    }
    Drag.active: mouseArea.drag.active
    */

    Drag.hotSpot: Qt.point(width/2, height/2)
    //Drag.source: root

    Item {
        id: box
        anchors.fill: parent
        children: [
            // Using Qt.binding() to bind the modelData property, otherwise this
            // binding of the children will treat root.modelData as a dependecy of children
            // And recreate the object everytime modelData changes
            root.delegate.createObject(box, { modelData: Qt.binding(() => root.modelData) })
        ]
    }
}
