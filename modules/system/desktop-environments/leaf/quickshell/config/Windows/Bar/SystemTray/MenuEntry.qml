import "../../../Modules/Common" as Common
import "../../../" as Root
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

// An item in a SystemTray popup menu
MouseArea {
    id: root
    required property QsMenuEntry entry
    implicitHeight: background.height
    implicitWidth: box.width // 
    //Layout.fillWidth: true // But expand if allowed
    enabled: true
    hoverEnabled: true
    onClicked: {
        console.log('clicked')
        root.entry.triggered()
    }

    Rectangle {
        id: background
        color: root.containsMouse ? palette.accent : "transparent"
        radius: Root.State.rounding
        implicitHeight: box.height
        implicitWidth: parent.width
        WrapperItem {
            id: box
            margin: 4
            RowLayout {
                IconImage {
                    visible: root.entry.icon === ""
                    implicitSize: root.entry.icon !== "" ? 16 : 0
                    source: root.entry.icon
                }
                CheckBox {
                    visible: root.entry.buttonType === QsMenuButtonType.CheckBox
                    checkState: root.entry.checkState
                }
                RadioButton {
                    visible: root.entry.buttonType === QsMenuButtonType.RadioButton
                }
                Text { 
                    id: text
                    color: palette.text
                    text: root.entry.text
                }
            }
        }
    }
}
