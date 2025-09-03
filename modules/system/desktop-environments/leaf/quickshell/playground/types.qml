

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
            property QtObject test: undefined
            Component.onCompleted: console.log(`test: ${test}`)
        }
    }
}
