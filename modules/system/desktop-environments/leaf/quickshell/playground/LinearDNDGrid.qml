pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

FloatingWindow {
    color: "black"

    GridView {
        id: gridView
        width: 200
        height: 600
        cellWidth: 48
        cellHeight: 48

        displaced: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }

        component Tile: Rectangle {
            id: tile

            width: 48
            height: 48
            
            property int index: 0

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            Text {
                anchors.centerIn: parent
                text: tile.index
            }

            DragHandler {
              id: dragHandler
              target: tile
            }

            //Drag.hotSpot: Qt.point(width/2, height/2)

            // In order for this item to emit drag events, the active state of this attached
            // property needs to be bound to the drag handler.
            Drag.active: dragHandler.active
            Drag.source: tile
            //Drag.hotSpot: Qt.point(24, 24)
            Drag.hotSpot.x: 24
            Drag.hotSpot.y: 24

            states: [
              State {
                when: dragHandler.active
                ParentChange { 
                  target: tile
                  parent: gridView
                }
                AnchorChanges {
                    target: tile
                    anchors {
                        horizontalCenter: undefined
                        verticalCenter: undefined
                    }
                }
              }
            ]
        }

        // Using a DelegateModel so that we can take advantage of the attached itemsIndex property and 
        // move() method on the items (DelegateModelGroup) property
        model: DelegateModel {
            id: delegateModel
            model: ScriptModel { values: ["blue", "red", "green", "blue", "blue", "blue", "blue", "red", "green", "pink"] }
            delegate: DropArea {
                id: dropArea
                required property string modelData
                property int index: DelegateModel.itemsIndex
                onEntered: (drag) => {
                  //console.log('drag ' + drag.source.modelData + ' ' + (drag.source as Tile).index)
                  delegateModel.items.move((drag.source as Tile).index, index, 1) // TODO: this causes the launcher to not open
                }
                width: 56
                height: 56

                Tile {
                    color: modelData

                    // fix?
                    //index: DelegateModel.itemsIndex // TODO: is this how to access an attached property?
                    index: dropArea.index // TODO: is this how to access an attached property?
                }
            }
        }
    }
}
