import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../" as Root

WrapperMouseArea { 
    id: root
    required property string text
    required property string iconName
    required property var action

    Layout.fillWidth: true

    enabled: true
    hoverEnabled: true
    onClicked: action()

    WrapperRectangle {
        margin: 4
        radius: Root.State.rounding
        color: root.containsMouse ? palette.highlight : "transparent"
        RowLayout {
            IconImage {
                implicitSize: 18
                source: Quickshell.iconPath(root.iconName)
            }
            Text {
                color: palette.text
                text: root.text
                Layout.fillWidth: true
            }
        }
    }
}
