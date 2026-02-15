import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets
import qs as Root

WrapperMouseArea {
    id: root
    required property string imgName
    property int imgSize: 32
    signal leftClick()
    signal rightClick()

    enabled: true
    hoverEnabled: true

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: (event) => {
        switch(event.button) {
            case Qt.LeftButton:
                leftClick(); break
            case Qt.RightButton:
                rightClick(); break
            default:
                console.error("button problem")
        }
    }
    margin: 4
    WrapperRectangle {
        margin: 4
        radius: 12
        color: root.containsMouse ? Root.State.colors.primary : "transparent"
        Rectangle {
            color: "transparent"
            implicitHeight: 32
            implicitWidth: 32
            IconImage {
                implicitSize: root.imgSize
                anchors.centerIn: parent
                source: Quickshell.iconPath(root.imgName)
            }
        }
    }
}
