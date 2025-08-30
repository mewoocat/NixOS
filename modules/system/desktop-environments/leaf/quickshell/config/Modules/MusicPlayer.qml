import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.Modules.Common as Common

RowLayout {
    id: root
    anchors.fill: parent
    property int margins: 16

    IconImage {
        id: image
        Layout.margins: root.margins
        implicitSize: parent.height - root.margins * 2
        source: "file:/home/eXia/Nextcloud/PicturesAndVideos/cat.jpg"
    }

    // For some reason the ColumnLayout layout won't fully fill width but the rectangle does
    Rectangle {
        id: box
        color: "transparent"
        Layout.fillHeight: true
        Layout.fillWidth: true

        Layout.topMargin: root.margins
        Layout.bottomMargin: root.margins
        Layout.rightMargin: root.margins

        ColumnLayout {
            //Layout.fillWidth: true
            Text {
                text: "title"
            }

            Text {
                text: "artist"
                font.pointSize: 8
            }

            ProgressBar {
                value: 0.4
                implicitWidth: box.width
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Common.NormalButton {
                    iconName: "player_rew"
                }
                Common.NormalButton {
                    iconName: "player_play"
                }
                Common.NormalButton {
                    iconName: "player_fwd"
                }
            }
        }
    }
}
