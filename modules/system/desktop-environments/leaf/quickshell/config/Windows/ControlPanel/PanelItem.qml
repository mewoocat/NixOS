import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

MouseArea {
    id: mouseArea
    required property var action
    property string iconName: ""
    property bool isClickable: true
    property real size

    Layout.preferredWidth: Layout.columnSpan > 1 ? size * Layout.columnSpan : size
    Layout.preferredHeight: size

    Component.onCompleted: {
        size = parent.width / 2
        console.log("size: " + size)
    }

    //Layout.fillWidth: parent.width / 2
    /*
    implicitHeight: 80
    onWidthChanged: {
        console.log("width: " + width)
    }
    //Layout.fillHeight: true
    //implicitHeight: parent.width
    Component.onCompleted: {
        console.log(parent.width / 2)
        mouseArea.implicitHeight = width
    }
    */

    enabled: isClickable // Whether mouse events are accepted
    //implicitWidth: 80
    //implicitHeight: 80
    hoverEnabled: true
    onClicked: action()
    Rectangle {
        id: box
        anchors.fill: parent
        anchors.margins: 8
        //anchors.centerIn: parent
        //implicitWidth: iconName != "" ? icon.width + 16 : text.width + 16
        //implicitWidth: 72
        //implicitHeight: 72
        radius: 24
        color: mouseArea.containsMouse ? "grey" : "#00000000"

        IconImage {
            //Rectangle { anchors.fill: parent; color: "#9900ff00" }
            anchors.centerIn: parent
            id: icon
            implicitSize: 32
            source: Quickshell.iconPath(mouseArea.iconName)
        }
   }
}
