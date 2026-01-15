pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

Item {
    id: root
    required property var model
    required property Component delegate
    GridView {
        width: 48
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


        // Using a DelegateModel so that we can take advantage of the attached itemsIndex property and 
        // move() method on the items (DelegateModelGroup) property
        model: DelegateModel {
            id: delegateModel
            //model: ScriptModel { values: ["blue", "red", "green", "blue", "blue", "blue", "blue", "red", "green", "pink"] }
            model: ScriptModel { values: root.model }

            // Note that the DropArea component can't be part of the actually dragged component, since moving the DropArea
            // will cause the grid to no longer render a spot for it
            delegate: DropArea {
                id: dropArea
                required property var modelData
                property int index: DelegateModel.itemsIndex
                onEntered: (drag) => {
                    delegateModel.items.move((drag.source as SequentialDragTile).index, index, 1)
                }
                width: 56
                height: 56

                SequentialDragTile {
                    dragGrid: root
                    index: dropArea.index
                    delegate: root.delegate
                    delegateData: dropArea.modelData
                }
            }
        }
    }
}
