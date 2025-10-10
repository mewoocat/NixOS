
import QtQuick
import Quickshell

FloatingWindow {
    id: root
    color: "grey"

    component GridItem: MouseArea {
        id: gridItem
        required property var grid // the grid parent
        drag.target: gridItem
        onReleased: {
            let newCol = Math.round(x / grid.unitSize)
            let newRow = Math.round(y / grid.unitSize)
            x = newCol * grid.unitSize
            y = newRow * grid.unitSize
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: 4
            color: "red"
        }
    }

    component GridArea: Rectangle {
        id: grid
        required property list<var> items
        property int unitSize: 64
        property int numRows: 6
        property int numColumns: 8
        color: "black"
        implicitWidth: unitSize * numColumns
        implicitHeight: unitSize * numRows

        Repeater {
            model: root.gridItems
            delegate: GridItem {
                required property var modelData
                grid: parent
                x: modelData.col * grid.unitSize
                y: modelData.row * grid.unitSize
                width: modelData.w * grid.unitSize
                height: modelData.h * grid.unitSize
            }
        }
    }

    property list<var> gridItems: [
        {
            row: 0,
            col: 0,
            w: 1,
            h: 1
        },
        {
            row: 2,
            col: 3,
            w: 2,
            h: 1
        }
    ]

    GridArea {}
}
