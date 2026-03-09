import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import qs as Root


// A header for a sub section of page
ColumnLayout {
    id: root
    required property string name
    property Component content: null

    // Header
    RowLayout {
        WrapperItem {
            Text {
                padding: 8
                color: Root.State.colors.on_surface
                text: root.name
            }
        }
        Item { Layout.fillWidth: true }
        Loader {
            Layout.rightMargin: 8
            sourceComponent: root.content
        }
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
