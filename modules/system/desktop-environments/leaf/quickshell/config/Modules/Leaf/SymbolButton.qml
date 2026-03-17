import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

import qs as Root

Button {
    id: control
    contentItem: Item {
        implicitHeight: row.height
        implicitWidth: row.width
        RowLayout {
            id: row
            anchors.centerIn: parent
            spacing: 0
            Text {
                id: symbol
                text: control.icon.name
                //font.pointSize: Math.max(control.icon.width, control.icon.height)
                font.pointSize: 18
                font.family: "Material Symbols Rounded"
                color: control.icon.color
            }
            Text {
                id: text
                Layout.alignment: Qt.AlignVCenter
                text: control.text
                color: control.textColor
            }
        }
    }
}
