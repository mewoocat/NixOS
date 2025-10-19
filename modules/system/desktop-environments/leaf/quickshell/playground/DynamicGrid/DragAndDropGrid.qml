pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

FloatingWindow {
    id: root
    color: "grey"

    property list<var> widgets: []
    
    /*
    component Item2: GridItem {
        widgetId: "item2"
        cellRowSpan: 1
        cellColumnSpan: 2

        Rectangle {
            anchors.fill: parent
            anchors.margins: 4
            color: "blue"
        }
    }
    component Item3: GridItem {
        widgetId: "item3"
        cellRowSpan: 2
        cellColumnSpan: 2

        Rectangle {
            anchors.fill: parent
            anchors.margins: 4
            color: "green"
        }
    }
    */

    // Determines whether two rectangles overlap given both of their top left most and bottom 
    // right most points.  This assumes x+ is right and y+ is down. Will return true if top left
    // point of B is less than the bottom right point of B and the bottom right point of B is 
    // greater than the top level point of A.
    function doItemsOverlap(A1, A2, B1, B2): bool {
        console.log("[CHECKING] for overlap")
        if (
            A1.x < B2.x &&
            A1.y < B2.y && 
            A2.x > B1.x &&
            A2.y > B1.y
        ) {
            console.log("overlap detected")
            return true
        }
        return false
    }

    RowLayout {
        Button {
            text: "add"
            onClicked: root.widgets.push({
                id: Math.random().toString().substr(2),
                widgetId: "item1",
                row: 0, col: 0, w: 1, h: 1
            })
        }
        Button {
            text: "add long"
            onClicked: root.widgets.push({
                id: Math.random().toString().substr(2),
                widgetId: "item2",
                row: 0, col: 0, w: 2, h: 1
            })
        }
        Button {
            text: "add big"
            onClicked: root.widgets.push({
                id: Math.random().toString().substr(2),
                widgetId: "item3",
                row: 0, col: 0, w: 2, h: 2
            })
        }
        Button {
            text: "root.widgets"
            onClicked: console.log(JSON.stringify(root.widgets,null,4))
        }
    }

    GridArea {
        id: area
        x: 40
        y: 40

        model: root.widgets
        availableWidgets: [
            WidgetDef {
                widgetId: "item1"
                cellRowSpan: 1
                cellColumnSpan: 1
                content: Item1 {}
            },
            WidgetDef {
                widgetId: "item2"
                cellRowSpan: 1
                cellColumnSpan: 2
                content: Item2 {}
            }
        ]
        // Hanlder for updating source model
        onModelUpdated: (model) => root.widgets = model
    }
}
