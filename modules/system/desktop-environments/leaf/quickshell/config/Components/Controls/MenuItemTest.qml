import QtQuick
import QtQuick.Controls.impl // For IconLabel
import QtQuick.Templates as T

import qs as Root

T.MenuItem {
    id: control

    hoverEnabled: true
    
    implicitWidth: 80
    implicitHeight: 40

    background: Rectangle {
        id: bg
        implicitWidth: 48//control.contentItem.implicitWidth + control.padding
        implicitHeight: 28//control.contentItem.implicitHeight + control.padding
        color: control.hovered ? "red" : "gray"
        radius: 4
    }

    spacing: 4
    icon.name: ""
    icon.source: ""
    icon.width: 24
    icon.height: 24
    icon.color: "blue"

    contentItem: IconLabel {
        alignment: Qt.AlignLeft
        id: iconLabel
        icon.name: control.icon.name
        icon.color: control.icon.color
        icon.width: control.icon.width
        icon.height: control.icon.height
        text: control.text
        spacing: control.spacing
        font.pointSize: control.font.pointSize
        font.family: control.font.family
        color: "green"
        leftPadding: 6
        // Icons generally seem to have a bit of padding built in, if text is included, add more padding to balance it out
        rightPadding: control.text != "" && control.icon.name != "" ? 8 : 6
    }
}
