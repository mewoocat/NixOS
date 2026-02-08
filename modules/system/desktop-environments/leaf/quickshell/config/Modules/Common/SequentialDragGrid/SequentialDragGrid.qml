pragma ComponentBehavior: Bound

import Quickshell
import QtQuick

Item {
    id: root
    required property var model // A list of IDs
    required property Component delegate

    signal modelUpdated(model: var) // When the model has been modified

    property int tileSize: 48

    GridView {
        width: root.tileSize
        height: root.height
        Component.onCompleted: console.debug(`gridview height: ${height}`)
        // These have a default of 100, so we need to set them
        cellWidth: root.tileSize
        cellHeight: root.tileSize

        clip: true // Hide items outside the GridView bounds
        acceptedButtons: Qt.NoButton // Disable dragging the view with the mouse since it makes it hard to drag the tiles

        displaced: Transition {
            NumberAnimation {
                properties: "x,y"
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }

        // Using a DelegateModel behaves a proxy visual model which can be manipulated without affected the source model
        // Useful for manipulating the view using the move() method
        model: DelegateModel {
            id: delegateModel
            //model: ScriptModel { values: ["blue", "red", "green", "blue", "blue", "blue", "blue", "red", "green", "pink"] }
            model: root.model

            // Note that the DropArea component can't be part of the actually dragged component, since moving the DropArea
            // will cause the grid to no longer render a spot for it
            delegate: DropArea {
                id: dropArea
                required property var modelData
                required property int index // special index role (like modelData), holds the index of the modelData for list based models
                property int visualIndex: DelegateModel.itemsIndex
                onEntered: (drag) => {
                    console.log(`onEntered`)
                    // Modify the visual model
                    delegateModel.items.move((drag.source as SequentialDragTile).visualIndex, visualIndex, 1)
                    console.log(`tile visual index: ${(drag.source as SequentialDragTile).visualIndex}`)
                }
                /*
                onDropped: (drop) => {
                    console.log(`onDropped`)

                    const originalIndex = dropArea.index // The original index of the item in the source model
                    const newIndex = dropArea.visualIndex // The desired index indicated by the placement of this delegate in the visual model
                    console.log(`originalIndex: ${originalIndex}`)
                    console.log(`newIndex: ${newIndex}`)

                    const removedValues = root.model.splice(originalIndex, 1) // Remove value at the original index
                    const draggedValue = removedValues[0]

                    // Insert dragged item at new index in model
                    root.model.splice(newIndex, 0, draggedValue)
                    console.log(`modified model ${root.model}`)

                    root.modelUpdated(root.model)
                }
                */
                width: root.tileSize
                height: root.tileSize

                SequentialDragTile {
                    dragGrid: root
                    index: dropArea.index
                    visualIndex: dropArea.visualIndex
                    delegate: root.delegate
                    modelData: dropArea.modelData

                    onDropped: {

                        console.log(`onDropped`)

                        const originalIndex = dropArea.index // The original index of the item in the source model
                        const newIndex = dropArea.visualIndex // The desired index indicated by the placement of this delegate in the visual model
                        console.log(`originalIndex: ${originalIndex}`)
                        console.log(`newIndex: ${newIndex}`)

                        const removedValues = root.model.splice(originalIndex, 1) // Remove value at the original index
                        const draggedValue = removedValues[0]

                        // Insert dragged item at new index in model
                        root.model.splice(newIndex, 0, draggedValue)
                        console.log(`modified model ${root.model}`)

                        root.modelUpdated(root.model)
                    }
                }
            }
        }
    }
}
