import Quickshell
import QtQuick
import QtQuick.Controls


PanelWindow {
    width: 400
    height: 400
    focusable: false // <- this cause problem
    Rectangle {
        anchors.fill: parent
        ComboBox {
            model: ["a", "b", "c", "d", "e"]
            popup.popupType: Popup.Window
            popup.x: -20
        }
    }
}
