import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import qs.Services as Services

WrapperMouseArea {
    id: root
    required property string imgPath

    enabled: true
    hoverEnabled: true
    onClicked: console.log("clicked")
    margin: 4

    WrapperRectangle {
        margin: 4
        radius: 12
        color: root.containsMouse ? palette.highlight : palette.base
        ClippingRectangle {
            radius: 20
            implicitWidth: 32
            implicitHeight: 32
            IconImage {
                implicitSize: 32
                anchors.centerIn: parent
                source: Services.User.pfpPath
            }
        }
    }
}
