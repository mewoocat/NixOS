pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root
    property bool visible: false

    function activate() {
        visible = true 
        visibleTimer.restart()
    }

    Timer {
        id: visibleTimer
        interval: 1000
        onTriggered: () => {
            root.visible = false
        }
    }
}
