import QtQuick
import Quickshell

PanelWindow {
    id: root
    width: 200
    height: 40
    color: "red"
    Rectangle {
        id: box
        color: "green"
        width: 40
        height: 40
    }
    PopupWindow {
        width: 200
        height: 200
        color: "transparent"
        anchor {
            item: box
            edges: Edges.Bottom | Edges.Left
        }
        //anchor.gravity: Edges.Bottom | Edges.Right
        visible: true
        Rectangle {
            anchors.centerIn: parent
            width: 100
            height: 100
            color: "#44000000"
        }
    }
}
