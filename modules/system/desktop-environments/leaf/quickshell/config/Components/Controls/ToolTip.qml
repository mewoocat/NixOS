import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import qs as Root

ToolTip {
    //delay: 300
    delay: Application.styleHints.mousePressAndHoldInterval
    background: Rectangle {
        radius: 20
        property color backgroundColor: Root.State.colors.surface
        color: Qt.rgba(backgroundColor.r, backgroundColor.g, backgroundColor.b, 1) // Force color to be opaque for now
    }
}
