pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: grid
    signal modelUpdated(model: list<var>)
    required property list<var> model
    required property list<WidgetDef> availableWidgets

    property int unitSize: 64
    property int numRows: 4
    property int numColumns: 8
    property GridItem selectedItem: null
    property int selectedTargetRow: {
        if (!selectedItem) { return 0 }
        let proposedRow = Math.round(selectedItem.y / unitSize)
        if (proposedRow > numRows - 1) { return numRows - 1 }
        if (proposedRow < 0) { return 0 }
        return proposedRow
    }
    property int selectedTargetColumn: {
        if (!selectedItem) { return 0 }
        let proposedCol = Math.round(x / unitSize)
        if (proposedCol > numColumns - 1) { return numColumns - 1 }
        if (proposedCol < 0) { return 0 }
        return proposedCol
    }
    width: unitSize * numColumns
    height: unitSize * numRows
    color: "black"

    function findSpot(def: WidgetDef) {
        // Iterate over each possible spot
        for (let row = 0; row < numRows; row++) {
            for (let col = 0; col < numColumns; col++){
                // Check if can fit the widget
                model.forEach(existingDef => {
                    // TODO
                })
            }
        }
    }

    function addWidget(widgetId: string) {
        const widgetDef = availableWidgets.find(def => def.widgetId === widgetId)
        if (!widgetDef) { console.error(`Could not add widget: ${widgetId}`); return }



        const jsonDef = {
            id: Math.random().toString().substr(2),
            widgetId: widgetId,
            row: 0, col: 0, 
            w: widgetDef.cellColumnSpan,
            h: widgetDef.cellRowSpan
        }
    }

    Item {
        id: targetGhost
        x: grid.selectedTargetColumn * grid.unitSize
        y: grid.selectedTargetRow * grid.unitSize
        visible: grid.selectedItem != null
        width: grid.selectedItem?.width
        height: grid.selectedItem?.height
        Rectangle {
            color: "white"
            anchors.fill: parent
            anchors.margins: 8
        }
    }

    Repeater {
        model: grid.model
        delegate: GridItem {
            id: gridItem
            required property var modelData
            unitSize: grid.unitSize
            row: modelData.row
            column: modelData.col
            cellRowSpan: modelData.h
            cellColumnSpan: modelData.w
            onPositionUpdateRequested: (item) => {
                console.log(item)
            }
            Loader {
                id: loader
                anchors.fill: parent
                property Component widget: grid.availableWidgets.find(def => def.widgetId === gridItem.modelData.widgetId).content
                sourceComponent: widget
            }
        }
    }
}
