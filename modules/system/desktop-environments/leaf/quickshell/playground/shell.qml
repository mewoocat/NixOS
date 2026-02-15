
import Quickshell
import Quickshell.Widgets
import QtQuick

// WheelHandler no worky
ShellRoot {
    PanelWindow {
        anchors.right: true
        anchors.bottom: true
        implicitWidth: 400
        implicitHeight: 400
        Rectangle {
            anchors.fill: parent
            Rectangle {
                width: 200
                height: 200
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                color: "black"
                WrapperItem {
                    margin: 20
                    child: Rectangle {
                        implicitWidth: 20
                        implicitHeight: 20
                        color: "blue"
                    }
                }
            }
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
