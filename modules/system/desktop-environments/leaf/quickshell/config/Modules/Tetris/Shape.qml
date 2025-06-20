import QtQuick
import Quickshell

Item {
    id: root

    // Inline component representing a rotation for a single block of a shape
    /*
    component Rotation: QtObject {
        required property int xTransform
        required property int yTransform
    }
    */

    required property list<Block> blocks // References to the Blocks that compose this shape
    required property list<var> rotations // A list of possible rotations

    //////////////////////////////////////////////////////////////// 
    // Functions
    //////////////////////////////////////////////////////////////// 

    function moveLeft() {
        blocks.forEach((block) => {
            block.row - 1
        })
    }

    function moveRight() {

    }

    function moveDown() {
        console.log('moving down')
        root.blocks.forEach((block) => {
            console.log(`block: ${block}`)
            block.yPos = block.yPos + 1
        })
    }

    function rotateRight() {

    }

    function rotateLeft() {

    }

}
