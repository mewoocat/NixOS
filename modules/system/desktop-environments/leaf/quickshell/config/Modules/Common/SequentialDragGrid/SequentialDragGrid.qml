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
        height: 400
        // These have a default of 100, so we need to set them
        cellWidth: root.tileSize
        cellHeight: root.tileSize

        interactive: false // Disable scrolling by default

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
                required property int index // special index role (like modelData)
                property int visualIndex: DelegateModel.itemsIndex
                onEntered: (drag) => {
                    console.log(`onEntered`)
                    // Modify the visual model
                    delegateModel.items.move((drag.source as SequentialDragTile).visualIndex, visualIndex, 1)
                    console.log(`tile visual index: ${(drag.source as SequentialDragTile).visualIndex}`)

                    //console.log(`delegateModel.model.values: ${delegateModel.model.values}`)
                    //root.modelUpdated(delegateModel.model)

                    // Swap the entrys in the model
                    /*
                    const draggedIndex = (drag.source as SequentialDragTile).index
                    const replacedEntry = root.model[dropArea.index]
                    root.model[dropArea.index] = root.model[draggedIndex]
                    root.model[draggedIndex] = replacedEntry

                    console.log(`Grid side model: ${root.model}`)
                    root.modelUpdated(root.model)
                    */
                }
                onDropped: (drop) => {

                    // Remove dragged item from model
                    const draggedIndex = (drag.source as SequentialDragTile).index
                    const removedValues = root.model.splice(draggedIndex, 1)
                    const draggedValue = removedValues[0]

                    console.log(`dragged index: ${draggedIndex}`)
                    console.log(`drop index: ${dropArea.index}`)

                    // Insert dragged item at new index in model
                    root.model.splice(DropArea.index, 0, draggedValue)

                    root.modelUpdated(root.model)
                }
                width: root.tileSize
                height: root.tileSize

                SequentialDragTile {
                    dragGrid: root
                    index: dropArea.index
                    visualIndex: dropArea.visualIndex
                    delegate: root.delegate
                    modelData: dropArea.modelData
                }
            }
        }
    }
}
