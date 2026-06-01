import QtQuick
import Quickshell

Item {
    id: root

    required property list<var> orientations // A list of possible rotations
    required property BlockStyle style
    property int currentOrientation: 0 // Index of the current orientation
    property list<Block> blocks // References to the Blocks that compose this shape
    property var originPos: ({x: 0, y: 0}) // current position of the top left corner of the shape.  All blocks belonging to this 
                                           // shape are placed using their orientation position relative to this position
}
