import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts
import "../../../" as Root

PageBase {
    pageName: "General"
    content: ColumnLayout {
        anchors.fill: parent
        Rectangle {
            color: "transparent"
            Layout.fillWidth: true
            implicitHeight: header.height + items.height
            Rectangle {
                id: header
                anchors.left: parent.left
                anchors.right: parent.right
                implicitHeight: 40
                color: "transparent"
                Text {
                    anchors.left: parent.left
                    text: "Little header......."
                    color: palette.text
                }
            }
            Rectangle {
                color: palette.base
                id: items
                anchors.top: header.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                ColumnLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    Rectangle {
                        radius: Root.State.rounding
                        color: "red"
                        Layout.fillWidth: true
                        implicitHeight: 100
                        Layout.margins: 20
                    }
                    Rectangle {
                        radius: Root.State.rounding
                        color: "red"
                        Layout.fillWidth: true
                        implicitHeight: 100
                        Layout.margins: 20
                    }
                    Rectangle {
                        radius: Root.State.rounding
                        color: "red"
                        Layout.fillWidth: true
                        implicitHeight: 100
                        Layout.margins: 20
                    }
                }
            }
        }
    }
}
