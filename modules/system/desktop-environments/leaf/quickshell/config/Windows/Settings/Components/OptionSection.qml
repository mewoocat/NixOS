import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root
    required property string name
    required property list<Item> options // An item with options as it's children
    //implicitWidth: root.width
    Layout.fillWidth: true
    Layout.maximumWidth: 700
    Layout.minimumWidth: 200
    Layout.alignment: Qt.AlignHCenter
    // Sub header
    WrapperRectangle {
        id: header
        margin: 4
        color: "transparent"
        //color: "#ffff0000"
        Text {
            text: root.name
            font.pointSize: 14
            font.bold: true
            color: palette.text
        }
    }

    // Options
    Rectangle {
        id: box
        Layout.fillWidth: true
        implicitHeight: childrenRect.height
        //color: palette.window
        color: "transparent"
        WrapperRectangle {
            radius: 16
            margin: 16
            color: palette.alternateBase
            ColumnLayout {
                id: optionsList
                implicitWidth: box.width - parent.margin * 2
                spacing: 16
                children: root.options
            }
        }
    }
}
