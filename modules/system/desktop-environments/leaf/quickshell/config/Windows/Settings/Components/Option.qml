import QtQuick
import QtQuick.Layouts
import Quickshell
import QtQuick.Controls
import Quickshell.Widgets
import qs as Root

Rectangle {
    id: root
    required property Item content
    required property string title
    property string subtitle: ""
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

            // Text
            WrapperRectangle {
                color: "#00ff0000"
                Layout.fillWidth: true
                ColumnLayout {
                    //Layout.alignment: Qt.AlignVCenter
                    Text {
                        color: palette.text
                        text: root.title
                    }
                    Text {
                        color: palette.text
                        font.pointSize: 8
                        text: root.subtitle
                    }
                }
            }

            // Control
            WrapperRectangle {
                color: "#00ff0000"
                children: [ root.content ]
            }
        }
    }
}
