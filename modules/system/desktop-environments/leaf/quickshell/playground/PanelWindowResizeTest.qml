import Quickshell
import QtQuick
import QtQuick.Controls

PanelWindow {
    id: root
    implicitWidth: 200
    Behavior on implicitWidth {
        PropertyAnimation { 
            duration: 1000
            easing.type: Easing.Linear
        }
    }
    implicitHeight: 200
    color: "red"
    Button {
        text: "large"
        onClicked: root.implicitWidth = 400
    }
    Button {
        y: 40
        text: "small"
        onClicked: root.implicitWidth = 100
    }
}
