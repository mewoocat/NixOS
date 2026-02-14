
import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import qs as Root

// Designed to be used as a child of the PanelGrid type
MouseArea {
    id: mouseArea
    required property var content // Object to display
    required property int rows // how many rows this element will span
    required property int columns // how many columns this element will span

    property var action // Action on click
    property bool isClickable: true

    implicitHeight: parent.unitSize * rows
    implicitWidth: parent.unitSize * columns
    //Layout.fillWidth: true
    //Layout.fillHeight: true
    Layout.columnSpan: columns
    Layout.rowSpan: rows
    //Layout.alignment: Qt.AlignLeft | Qt. AlignTop

    enabled: isClickable // Whether mouse events are accepted
    hoverEnabled: true
    onClicked: action()

    // Shadow for the Rectangle
    // Note: If shadow extends beyond the window, it will create sharp corners
    RectangularShadow {
        visible: false
        anchors.fill: box
        offset.x: -1
        offset.y: -1
        radius: box.radius
        blur: 4
        spread: 4
        color: Qt.alpha(Qt.darker(palette.base, 2), 0.4)
    }

    Rectangle {
        id: box
        anchors.fill: parent
        anchors.margins: 6
        radius: Root.State.rounding
        color: mouseArea.containsMouse ? "red" : Root.State.colors.surface_container
        children: [
            mouseArea.content
        ]
   }
}
