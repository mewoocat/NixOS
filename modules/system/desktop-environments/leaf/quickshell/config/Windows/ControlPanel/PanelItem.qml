import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

MouseArea {
    id: mouseArea
    required property var action // Action on click
    required property var content // Object to display
    property string iconName: ""
    property bool isClickable: true

    Layout.fillWidth: true
    Layout.fillHeight: true

    // Wack solution
    /*
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
    hoverEnabled: true
    onClicked: action()
    Rectangle {
        id: box
        anchors.fill: parent
        anchors.margins: 4
        radius: 16
        color: mouseArea.containsMouse ? "grey" : palette.active.base

        children: [
            content
        ]
   }
}
