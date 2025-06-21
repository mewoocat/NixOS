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

    required property list<BlockDef> blockDefs
    required property list<var> rotations // A list of possible rotations

    property list<Block> blocks // References to the Blocks that compose this shape

    //////////////////////////////////////////////////////////////// 
    // Functions
    //////////////////////////////////////////////////////////////// 

    function moveLeft() {
        for (const block of root.blocks) {
            if (block.xPos - 1 < 0) {
                console.log('hit right')
                return
            }
        }
        root.blocks.forEach((block) => block.xPos--)
    }

    function moveRight() {
        for (const block of root.blocks) {
            if (block.xPos + 1 >= Tetris.gridColumns) {
                console.log('hit right')
                return
            }
        }

        root.blocks.forEach((block) => block.xPos++)
    }

    function moveDown() {
        //console.log('moving down')
        // Check if movement is allowed
        for (const block of root.blocks) {
            //console.log(`${block.yPos}`)
            // Lock shape if bottom of board is hit
            if (block.yPos + 1 >= Tetris.gridRows) {
                console.log('hit bottom')
                // Lock Shape
                root.blocks.forEach((block) => {
                    Tetris.gameGrid[block.xPos][block.yPos] = block // Lock Block
                })
                Tetris.addShape()
                return
            }
            // Lock shape if another block is hit
            if (Tetris.gameGrid[block.xPos][block.yPos + 1] !== null) {
                console.log('hit block')
                // Lock Shape
                root.blocks.forEach((block) => {
                    Tetris.gameGrid[block.xPos][block.yPos] = block // Lock Block
                })
                Tetris.addShape()
                return
            }
        }
        // Then perform actual movement
        root.blocks.forEach((block) => {
            block.yPos = block.yPos + 1
        })
    }

    function rotateRight() {
    }

    function rotateLeft() {

    }

}
