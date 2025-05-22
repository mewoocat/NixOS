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
