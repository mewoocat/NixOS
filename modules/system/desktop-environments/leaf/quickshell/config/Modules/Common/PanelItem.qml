import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

// Designed to be used as a child of the PanelGrid type
MouseArea {
    id: mouseArea
    required property var action // Action on click
    required property var content // Object to display
    required property int rows // how many rows this element will span
    required property int columns // how many columns this element will span

    property bool isClickable: true

    implicitHeight: parent.unitSize * rows
    implicitWidth: parent.unitSize * columns
    //Layout.fillWidth: true
    //Layout.fillHeight: true
    Layout.columnSpan: columns
    Layout.rowSpan: rows

    enabled: isClickable // Whether mouse events are accepted
    hoverEnabled: true
    onClicked: action()
    Rectangle {
        id: box
        anchors.fill: parent
        anchors.margins: 4
        radius: 16
        color: mouseArea.containsMouse ? palette.highlight : palette.base
        children: [
            content
        ]
   }
}
