import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root
    required property list<Item> options // An item with options as it's children
    //implicitWidth: root.width
    Layout.fillWidth: true
    Layout.maximumWidth: 700
    Layout.minimumWidth: 200
    Layout.alignment: Qt.AlignHCenter
    spacing: 16

    // Sub header
    WrapperRectangle {
        id: header
        //margin: 4
        color: "#00000000"
        Text {
            text: "Little header......."
            color: palette.text
        }
    }

    // Options
    Item {
        id: box
        Layout.fillWidth: true
        implicitHeight: optionsList.height
        WrapperRectangle {
            radius: 16
            margin: 16
            color: palette.window
            ColumnLayout {
                id: optionsList
                implicitWidth: box.width - parent.margin * 2
                spacing: 16
                children: root.options
            }
        }
    }
}
