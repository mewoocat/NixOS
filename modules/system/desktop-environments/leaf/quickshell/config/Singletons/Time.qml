pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property var date: new Date()
    property string time: date.toLocaleString(Qt.locale(), "MMMM d  h:mm ap")

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.date = new Date()
    }
}
