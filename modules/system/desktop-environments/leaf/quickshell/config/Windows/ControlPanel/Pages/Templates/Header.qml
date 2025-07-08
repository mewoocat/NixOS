import Quickshell
import QtQuick
import QtQuick.Layouts
import '../../../../Modules/Common/' as Common
import '../../../../' as Root

// Header
RowLayout {
    id: root
    required property string name

    Layout.fillWidth: true
    Common.NormalButton {
        text: "Back"
        leftClick: () => Root.State.controlPanelPage = 0
    }

    /*
    Rectangle {
        implicitHeight: 40
        implicitWidth: 40
        Layout.alignment: Qt.AlignRight
        color: "red"
    }
    */
    
    // Name
    Text {
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignRight
        color: palette.text
        font.bold: true
        text: root.name
    }
}
