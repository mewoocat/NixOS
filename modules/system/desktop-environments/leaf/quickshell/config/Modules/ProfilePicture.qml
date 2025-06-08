import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
//import Qt5Compat.GraphicalEffects
import "../Services/" as Services

MouseArea {
    id: root
    implicitHeight: 64
    implicitWidth: 64

    // Rounds the image
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
