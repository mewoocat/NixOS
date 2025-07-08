import Quickshell
import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root
    required property string name

    // Title
    Text {
        color: palette.text
        text: root.name
        //font.bold: true
    }

    // Horizontal line
    /*
    Rectangle {
        radius: 20
        implicitHeight: 1
        Layout.fillWidth: true
        color: "#777777"
    }
    */
}
