import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

PanelWindow {
    id: root
    width: 400
    height: 400
    property bool thing: true
    onThingChanged: () => process.running = true
    Button {
        text: thing
        onClicked: () => thing = !thing
    }
    Process {
        id: process
        command: ["sh", "-c", `notify-send "${root.thing}"`]
    }
}
