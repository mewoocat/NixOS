import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root
    required property list<Item> options // An item with options as it's children
    implicitWidth: root.width
    spacing: 16

    // Sub header
    WrapperRectangle {
        id: header
        //margin: 4
        color: "green"
        Text {
            text: "Little header......."
            color: palette.text
        }
    }
    // Options
    Rectangle {
        Layout.fillWidth: true
        radius: 16
        color: palette.base
        implicitHeight: optionsList.height
        ColumnLayout {
            id: optionsList
            implicitWidth: parent.width
            spacing: 16
            children: root.options
        }
    }
}
