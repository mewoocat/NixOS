import QtQuick
import Quickshell

Item {
    id: root

    required property list<var> orientations // A list of possible rotations
    property int currentOrientation: 0 // Index of the current orientation
    property list<Block> blocks // References to the Blocks that compose this shape
    property var originPos: ({x: 0, y: 0}) // current position of the top left corner of the shape.  All blocks belonging to this 
                                            // shape are placed using their orientation position relative to this position

    //////////////////////////////////////////////////////////////// 
    // Functions
    //////////////////////////////////////////////////////////////// 

    function moveLeft() {
        // Check for out of bounds
        for (const block of root.blocks) {
            if (block.xPos - 1 < 0) {
                console.log('hit right')
                return
            }

            // Check for collision with block
            if (Tetris.gameGrid[block.xPos - 1][block.yPos] !== null) {
                console.log('hit block')
                return
            }
        }

        root.originPos.x -= 1 // Move origin position left
        // Then perform actual movement
        for (let i = 0; i < root.blocks.length; i++){
            // Move each block down by setting it's position to its origin + offset
            blocks[i].xPos = root.originPos.x + root.orientations[currentOrientation][i].x
        }
    }

    function moveRight() {
        // Check for out of bounds
        for (const block of root.blocks) {
            if (block.xPos + 1 >= Tetris.gridColumns) {
                console.log('hit right')
                return
            }

            // Check for collision with block
            if (Tetris.gameGrid[block.xPos + 1][block.yPos] !== null) {
                console.log('hit block')
                return
            }
        }

        root.originPos.x += 1 // Move origin position right
        // Then perform actual movement
        for (let i = 0; i < root.blocks.length; i++){
            // Move each block down by setting it's position to its origin + offset
            blocks[i].xPos = root.originPos.x + root.orientations[currentOrientation][i].x
        }
    }

    function moveDown() {
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
        root.originPos.y += 1 // Move origin position down
        // Then perform actual movement
        for (let i = 0; i < root.blocks.length; i++){
            // Move each block down by setting it's position to its origin + offset
            blocks[i].yPos = root.originPos.y + root.orientations[currentOrientation][i].y
        }
    }

    function rotateRight() { 
        root.currentOrientation++
        // Reset to 0 if was at last index
        if (root.currentOrientation >= root.orientations.length) {
            root.currentOrientation = 0
        }
        // New orientation
        let orientation = root.orientations[currentOrientation]
        // For each block
        for (let i = 0; i < root.blocks.length; i++) {
            // Apply the corresponding transform
            blocks[i].xPos = root.originPos.x + orientation[i].x
            blocks[i].yPos = root.originPos.y + orientation[i].y
        }
    }

    function rotateLeft() {

    }

}
