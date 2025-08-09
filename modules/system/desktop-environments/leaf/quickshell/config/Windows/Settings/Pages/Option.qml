import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import Quickshell.Widgets
import "../../../" as Root

Rectangle {
    id: root
    radius: Root.State.rounding
    color: palette.base
    Layout.fillWidth: true
    implicitHeight: 40 + 16 * 2
    WrapperRectangle {
        margin: 16
        color: "#00ff0000"
        RowLayout {
            id: content
            implicitWidth: root.width - parent.margin * 2
            implicitHeight: root.height
            WrapperRectangle {
                color: "#00ff0000"
                Layout.fillWidth: true
                ColumnLayout {
                    //Layout.alignment: Qt.AlignVCenter
                    Text {
                        color: palette.text
                        text: "Option thingy"
                    }
                    Text {
                        color: palette.text
                        font.pointSize: 8
                        text: "Option thingy"
                    }
                }
            }
            WrapperRectangle {
                color: "#00ff0000"
                Switch {
                    text: "what"
                    contentItem: null // Remove default text element which was reserving space
                }
            }
        }
    }
}
