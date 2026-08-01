pragma Singleton
import Quickshell
import QtQuick

Singleton {
    id: root
    property bool visible: false
    property string mode: "" // volume, brightness

    function activate(targetMode: string) {
        mode = targetMode
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
