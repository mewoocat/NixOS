import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs as Root

// For generic popup menus
WrapperMouseArea { 
    id: root
    required property string text
    required property var action
    property string iconName: ""

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
                visible: root.iconName != ""
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
