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
    required property list<Rotation> rotations // A list of possible rotations

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

    }

    function rotateRight() {

    }

    function rotateLeft() {

    }

}
