pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets

FloatingWindow {
    id: root

    property list<var> things: [
        {
            name: "A"
        },
        {
            name: "B"
        }
    ]

    function generateModel(things: list<var>): list<var> {
        return things.map(t => {
            const component = Qt.createComponent("TestData.qml")
            const obj = component.createObject(null, {
                name: t.name,
                something: "what"
            })
            return obj
        })
    }

    ColumnLayout {
        Repeater {
            model: root.generateModel(root.things)
            delegate: WrapperRectangle {
                implicitWidth: 200
                implicitHeight: 200
                color: "green"
                required property var modelData
                Text {
                    text: modelData.something
                }
            }
        }
    }
}
