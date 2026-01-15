pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Rectangle {
    id: root 

    required property Item dragGrid // The ancestor grid
    required property Component delegate // The content to render
    required property int index // The current index of this tile within the grid
    required property var delegateData

    width: 48
    height: 48
    anchors {
        horizontalCenter: parent.horizontalCenter
        verticalCenter: parent.verticalCenter
    }
    states: [
        // When dragging, parent the dragged item to the grid instead of it's DropArea
        State {
            when: dragHandler.active
            ParentChange { 
              target: root
              parent: root.dragGrid
            }
            // IDK if this is needed
            AnchorChanges {
                target: root
                anchors {
                    horizontalCenter: undefined
                    verticalCenter: undefined
                }
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
    //Drag.hotSpot: Qt.point(width/2, height/2)
    Drag.hotSpot.x: 24
    Drag.hotSpot.y: 24

    // Load the desired content
    Loader {
        anchors.fill: parent
        sourceComponent: root.delegate
        Component.onCompleted: console.log(`Loader | ${delegateData}`)
        property alias delegateData: root.delegateData // Assumes that whatever component is passed in has a data property
    }
}
