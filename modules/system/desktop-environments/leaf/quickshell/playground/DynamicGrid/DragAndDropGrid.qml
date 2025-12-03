pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

FloatingWindow {
    id: root
    color: "grey"
 
    RowLayout {
        Button {
            text: "add"
            onClicked: area.addWidget("item1")
        }
        Button {
            text: "add long"
            onClicked: area.addWidget("item2")
        }
        Button {
            text: "add big"
            onClicked: area.addWidget("item3")
        }
        Button {
            text: "root.widgets"
            onClicked: console.log(JSON.stringify(root.widgets,null,4))
        }
    }


    // This represents the property which will be persisted
    property var widgets: []

    GridArea {
        id: area
        x: 40
        y: 40

        model: root.widgets // returns the values of the map as an array
        onModelUpdated: (model) => root.widgets = model // Hanlder for updating source model

        availableWidgets: [
            WidgetDef {
                widgetId: "item1"
                xSpan: 1
                ySpan: 1
                content: Item1 {}
            },
            WidgetDef {
                widgetId: "item2"
                xSpan: 2
                ySpan: 1
                content: Item2 {}
            },
            WidgetDef {
                widgetId: "item3"
                xSpan: 2
                ySpan: 2
                content: Item3 {}
            }
        ]
    }
}
