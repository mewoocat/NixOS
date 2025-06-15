import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets


WrapperMouseArea {
    id: root
    required property string imgPath
    required property var action
    property int imgSize: 32

    enabled: true
    hoverEnabled: true
    onClicked: action()
    margin: 4
    WrapperRectangle {
        margin: 4
        radius: 12
        color: root.containsMouse ? palette.highlight : palette.base
        Rectangle {
            color: "transparent"
            implicitHeight: 32
            implicitWidth: 32
            IconImage {
                implicitSize: root.imgSize
                anchors.centerIn: parent
                //source: Quickshell.iconPath('systemsettings')
                source: root.imgPath
            }
        }
    }
}
