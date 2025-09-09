import QtQuick
import Quickshell

FloatingWindow {
    color: "grey"

    Rectangle {
        id: box
        color: "red"
        implicitWidth: 100
        implicitHeight: 100
        Drag.onDragStarted: () => console.log(`drag started`)
        Drag.active: dragArea.drag.active
        MouseArea {
            id: dragArea
            anchors.fill: parent
            drag.target: box
        }
    }
}
