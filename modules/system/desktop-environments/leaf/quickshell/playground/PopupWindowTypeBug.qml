import Quickshell
import QtQuick
import QtQuick.Controls


PanelWindow {
    width: 400
    height: 400
    focusable: true // <- this cause problem
    Rectangle {
        anchors.fill: parent
        ComboBox {
            model: ["a", "b", "c", "d", "e"]
            Component.onCompleted: popup.popupType = Popup.Window
        }
    }
}
