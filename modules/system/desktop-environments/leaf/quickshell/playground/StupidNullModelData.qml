import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

FloatingWindow {
    id: root

    ColumnLayout {
        Repeater {
            property Component thing: Component {
                Rectangle {
                    id: testComp
                    color: "red"
                    Component.onCompleted: console.debug(`CREATED ${testComp}`)
                    Component.onDestruction: console.debug(`DELETED ${testComp}`)
                }
            }
            model: {
                const things = []
                things.push(thing.createObject())
                things.push(thing.createObject())
                things.push(thing.createObject())
                return things
            }
            delegate: WrapperRectangle {
                implicitWidth: 200
                implicitHeight: 200
                color: "green"
            }
        }
        Repeater {
            model: 10000
            delegate: Rectangle {
                width: 100
                height: 100
                color: "red"
            }
        }
    }
}
