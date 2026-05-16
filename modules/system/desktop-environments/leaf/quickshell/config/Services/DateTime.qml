pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property var dateObj: new Date()
    property string time: dateObj.toLocaleString(Qt.locale(), "h:mm ap")
    property string date: dateObj.toLocaleString(Qt.locale(), "MMMM d")

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.dateObj = new Date()
    }
}
