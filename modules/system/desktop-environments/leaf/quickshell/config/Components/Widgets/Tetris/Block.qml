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
    required property BlockStyle style
    required property int size
    border.width: 2
    border.color: style.borderColor

    implicitWidth: size
    implicitHeight: size
    color: style.color
    
    x: xPos * size
    y: yPos * size
    Component.onCompleted: console.debug(`created block with pos: ${x},${y}`)
}
