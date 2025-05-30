import Quickshell
import QtQuick
import "root:/Services/" as Services

FloatingWindow {

    //minimumSize: "200x300"

    component Monitor: MouseArea {
        Rectangle {
            anchors.fill: parent
            color: "red"
        }
    }

    Rectangle {
        anchors.centerIn: parent
        // Set to large enough size to accommodate the native size of multiple monitors
        implicitWidth: 10000
        implicitHeight: 10000
        // Scale down the size to actually be usable
        scale: 0.05
        color: "#76b710"

        Repeater {
            model: Services.Monitors.monitorObjs

            Monitor {
                required property var modelData
                Component.onCompleted: {
                    //console.log()
                }
            }
        }

    }
}
