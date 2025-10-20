pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

FloatingWindow {
    id: root
    color: "grey"

    property list<var> widgets: []
    
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
            },
            WidgetDef {
                widgetId: "item3"
                cellRowSpan: 2
                cellColumnSpan: 2
                content: Item3 {}
            }
        ]
        // Hanlder for updating source model
        onModelUpdated: (model) => root.widgets = model
    }
}
