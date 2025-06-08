import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets


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
        IconImage {
            implicitSize: 32
            anchors.centerIn: parent
            //source: Quickshell.iconPath('systemsettings')
            source: root.imgPath
        }
    }
}
