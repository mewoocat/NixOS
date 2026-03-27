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
    property int size: Tetris.blockSize
    border.width: 1
    border.color: "black"

    implicitWidth: size
    implicitHeight: size
    color: root.style
    
    x: xPos * size
    y: yPos * size
    Component.onCompleted: console.log(`created block with pos: ${x},${y}`)
}
