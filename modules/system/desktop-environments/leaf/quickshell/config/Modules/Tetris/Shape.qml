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
            if (Tetris.gameGrid[block.yPos][block.xPos - 1] !== null) {
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
            if (Tetris.gameGrid[block.yPos][block.xPos + 1] !== null) {
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

    function checkAndClearLines() {
        // How much to move down blocks by after line clears
        // + tells how many rows have been cleared
        let currentMoveDownAmount = 0

        Tetris.printGrid()

        // For each row, starting at the bottom
        for (let y = Tetris.gridRows - 1; y >= 0; y--) {
            console.log(`checking row ${y}`)
            // Assume the row is full
            let isFullRow = true

            // For each column in the row
            for (let x = 0; x < Tetris.gridColumns; x++) {
                // If empty space found
                if (Tetris.gameGrid[y][x] === null) {
                    isFullRow = false
                    // If the row needs to be moved down
                    if (currentMoveDownAmount > 0) {
                        // For each block in the row
                        // Move it down by the amount needed
                        Tetris.printGrid()
                        console.log('row = ' + Tetris.gameGrid[y])
                        for (let x = 0; x < Tetris.gridColumns; x++) {
                            let block = Tetris.gameGrid[y][x]
                            console.log(`looking at block: ${block}`)
                            // If the block space is empty, skip
                            if (block === null || block === 0) {
                                console.log('block skipped....')
                                continue
                            }
                            console.log(`original block: ${block}: ${block.yPos}, ${block.xPos}`)
                            gameGrid[block.yPos][block.xPos] = null // unset the previous position
                            block.yPos += currentMoveDownAmount // Move the block down
                            console.log(`moved down block: ${block.yPos}, ${block.xPos}`)
                            gameGrid[block.yPos][block.xPos] = block // set the new position
                        }
                        console.log(`finished moving down row`)
                    }
                    break // No need to continue through the row
                }
            }

            // The row was full, perform line clear
            if (isFullRow) {    
                console.log(`performing line clear`)
                // For each column in the row
                for (let x = 0; x < Tetris.gridColumns; x++) {
                    Tetris.gameGrid[y][x].destroy() // Destory the block
                    Tetris.gameGrid[y][x] = null // Unset it's position
                }
                // Since a line was cleared, anything above it will need to be moved 
                // down by 1 + the amount of other line clears below it
                currentMoveDownAmount++
            }

        }

        // Score amount per lines cleared
        // Derived from the NES level 0 as seen here: https://tetris.wiki/Scoring
        let scoreChart = [
            0,
            40,
            100,
            300,
            1200
        ]
        // Increase score
        Tetris.score += scoreChart[currentMoveDownAmount]
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
                    Tetris.gameGrid[block.yPos][block.xPos] = block // Lock Block
                })
                checkAndClearLines()
                Tetris.spawnShape()
                return
            }
            // Lock shape if another block is hit
            if (Tetris.gameGrid[block.yPos + 1][block.xPos] !== null) {
                console.log('hit block')
                // Lock Shape
                root.blocks.forEach((block) => {
                    Tetris.gameGrid[block.yPos][block.xPos] = block // Lock Block
                })
                checkAndClearLines()
                Tetris.spawnShape()
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
        const previousOrientation = root.currentOrientation
        root.currentOrientation++
        // Reset to 0 if was at last index
        if (root.currentOrientation >= root.orientations.length) {
            root.currentOrientation = 0
        }

        // New orientation
        let orientation = root.orientations[currentOrientation]

        // Check if block can be rotated
        for (let i = 0; i < root.blocks.length; i++) {
            const x = root.originPos.x + orientation[i].x
            const y = root.originPos.y + orientation[i].y
            // If any of the blocks can't be rotated, cancel the rotate
            if (Tetris.gameGrid[y][x] !== null) {
                root.currentOrientation = previousOrientation
                return
            }
        }

        // Rotate each block
        for (let i = 0; i < root.blocks.length; i++) {
            // Apply the corresponding transform
            blocks[i].xPos = root.originPos.x + orientation[i].x
            blocks[i].yPos = root.originPos.y + orientation[i].y
        }
    }

    function rotateLeft() {

    }

}
