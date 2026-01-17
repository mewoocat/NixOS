import Quickshell
import QtQuick

FloatingWindow {
    color: "black"

    Rectangle {
        color: "grey"
        width: 200
        height: 400
        
        DropArea {
            width: 200
            height: 200
            y: 200
            Rectangle {
                color: "green"
                anchors.fill: parent
            }
            onEntered: (drag) => {
                console.log(`entered`)
            }
            onDropped: (drop) => {
                console.log('drop')
            }
        }

        Rectangle {
            id: boxA
            width: 20
            height: 20
            Drag.active: dh.active

            DragHandler {
                id: dh
                target: boxA
            }
        }

        Rectangle {
            id: boxB
            width: 20
            height: 20
            x: 40
            Drag.active: ma.drag.active

            MouseArea {
                anchors.fill: parent
                id: ma
                onReleased: (mouse) => {
                    console.log(`trying to drop`)
                    boxB.Drag.drop()
                }
                drag.target: boxB

                MouseArea {
                    anchors.fill: parent
                    propagateComposedEvents: true
                    onClicked: (mouse) => {
                        console.log(`CLICKED`)
                        mouse.accepted = false
                    }
                }
            }
        }
    }
}
