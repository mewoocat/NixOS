import Quickshell
import QtQuick

PanelWindow {
    id: root
    width: 200
    height: 40
    color: "red"
    property list<QtObject> thing: [
        Item {},
        QtObject {}
    ]
}
