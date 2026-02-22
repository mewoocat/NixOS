import Quickshell
import QtQuick
import Qt5Compat.GraphicalEffects

FloatingWindow {
    Rectangle {
        color: "black"
        implicitWidth: 1000
        implicitHeight: 1200

        Rectangle {
            id: box
            visible: false
            color: "blue"
            implicitWidth: 100
            implicitHeight: 100
        }

        Rectangle {
            id: mask
            color: "transparent"
            visible: false
            implicitWidth: 100
            implicitHeight: 100
            Rectangle {
                color: "red"
                implicitWidth: 40
                implicitHeight: 40
            }
        }

        OpacityMask {
            anchors.fill: box
            source: box
            maskSource: mask
        }
    }
}

