import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

// Represents a single tile on the gameboard
// Will be used within a GridLayout
Rectangle {
    id: root

    required property int xPos
    required property int yPos
    required property string style // Just a color right now
    property int size: 8

    implicitWidth: root.size
    implicitHeight: root.size
    color: root.style
    //Layout.row: root.xPos
    //Layout.column: root.yPos
    
    x: xPos * size
    y: yPos * size
    Component.onCompleted: console.log(`created block with pos: ${x},${y}`)
}
