import "../../../Modules/Common" as Common
import "../../../" as Root
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

// An item in a SystemTray popup menu
MouseArea {
    id: mouseArea
    required property QsMenuEntry entry
    implicitHeight: background.height
    implicitWidth: box.width // 
    //Layout.fillWidth: true // But expand if allowed
    enabled: true
    hoverEnabled: true

    Rectangle {
        id: background
        color: mouseArea.containsMouse ? palette.accent : "transparent"
        radius: Root.State.rounding
        implicitHeight: box.height
        implicitWidth: parent.width
        WrapperItem {
            id: box
            margin: 4
            RowLayout {
                Text { 
                    id: text
                    color: palette.text
                    text: mouseArea.entry.text
                }
            }
        }
    }
}
