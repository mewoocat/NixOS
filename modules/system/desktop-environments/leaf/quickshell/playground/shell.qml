
import Quickshell
import QtQuick

// WheelHandler no worky
ShellRoot {
    PanelWindow {
        anchors.right: true
        anchors.bottom: true
        implicitWidth: 200
        implicitHeight: 200
        Rectangle {
            anchors.fill: parent
            Rectangle {
                focus: true
                enabled: true
                implicitHeight: 40
                implicitWidth: 40
                color: "green"
                WheelHandler {
                    onWheel: console.log('wheel')
                    property: "rotation"
                    acceptedModifiers: Qt.ControlModifier
                }

                WheelHandler {
                    onWheel: console.log('wheel')
                    property: "scale"
                    acceptedModifiers: Qt.NoModifier
                }
            }
        }
        Rectangle {
            color: "blue"
            width: 100; height: 100

            Rectangle {
                color: "green"
                width: 25; height: 25
            }

            Rectangle {
                color: "red"
                x: 25; y: 25; width: 50; height: 50
                scale: 1.4
                transformOrigin: Item.TopLeft
                Rectangle {
                    color: "green"
                    width: 25; height: 25
                }
            }
        }
    }
}
