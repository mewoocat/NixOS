import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Widgets

WrapperMouseArea {
    id: root
    required property string imgName
    required property var action
    property int imgSize: 32

    enabled: true
    hoverEnabled: true

    //propagateComposedEvents: true
    //preventStealing: true
    onClicked: (mouse) => {
        console.log(`SidePanelItem clicked`)
        action()
        //mouse.accepted = false
    }
    /*
    onReleased: (mouse) => {
        console.log(`action`)
        action()
        //mouse.accepted = false
    }
    onPressAndHold: (mouse) => {
        console.log(`press and hold`)
        mouse.accepted = false
    }
    */
    margin: 4
    WrapperRectangle {
        margin: 4
        radius: 12
        color: root.containsMouse ? palette.highlight : "transparent"
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
