import QtQuick

QtObject {
    id: root

    property int gridRows: 20
    property int gridColumns: 10
    property int blockSize: 14

    property Rectangle gameBoard: null // Ref to gameBoard
    property Rectangle nextShapeBoard: null // Ref to the nextShapeBoard
    property Shape activeShape: null // Player controlled shape
    property Shape nextShape: null // Next shape to spawn

    onActiveShapeChanged: console.log(`active shape changed to: ${activeShape}`)
    onNextShapeChanged: console.log(`next shape changed to: ${nextShape}`)

    property bool isRunning: false
    property bool isPaused: false
    property int score: 0

    property list<string> shapes: ["O", "T", "L", "S", "Z", "J", "I"]
    property int lastShapeIndex: 0

    // 2D array that holds gameboard state
    // Each item is null, or a ref to the block obj
    property var gameGrid: {
        let grid = new Array(root.gridRows)
        // Initialize with nulls
            // I could have sworn that you can just insert into whatever index you want 
            // but it's throwing a type error if I do that
        for (let y = 0; y < root.gridRows; y++) {
            grid[y] = new Array(root.gridRows)
            for (let x = 0; x < root.gridColumns; x++) {
                grid[y][x] = null
            }
        }
        //root.printGrid()
        return grid
    }

    function printGrid() {
        console.log("PRINTING GRID///////////////////////////////////////////////////")
        for (let y = 0; y < root.gridRows; y++) {
            let row = ""
            for (let x = 0; x < root.gridColumns; x++) {
                row += ` ${root.gameGrid[y][x]}`
            }
            console.log(row)
        }
    }

    function start() {
        console.log(`Starting tetris state singleton`)
        // Add shape if game is first starting
        if (!root.isPaused) {
            root.isRunning = true
            root.spawnShape()
        }
        Tetris.isPaused = false
        timer.running = true
    }

    function pause() {
        console.log(`Pausing tetris`)
        Tetris.isPaused = true
        timer.running = false
    }

    function reset() {
        console.log(`Resetting tetris`)
    }

    function createShape() {
        console.log('creating shape')

        // Get random number 0 -> shapes.length
        // And ensure that it wasn't the last picked shape
        let shapeIndex = root.lastShapeIndex
        while (shapeIndex === root.lastShapeIndex) {
            console.debug(`generating shape index`)
            shapeIndex = Math.floor(Math.random() * root.shapes.length)
        }

        // Get shape component by relative path
        const shapeComponent = `Shapes/${root.shapes[shapeIndex]}.qml`
        let component = Qt.createComponent(shapeComponent)
        let shape = component.createObject(null, {})

        return shape
    }

    function gameOver() {
        console.log(`game over`)
        timer.running = false
        root.isRunning = false
    }

    // TODO: have generic createBlocks method that gets called here for the active and next shapes 
    function spawnShape() {
        console.log('spawning shape')
        if (activeShape === null) {
            root.activeShape = createShape()
        }
        else {
            root.activeShape.destroy() // Destroy the existing shape obj since it's no longer active and just blocks now

            // Destroy all rendered blocks for the previous nextShape
            // Since we will recreate them when rendering it as the active shape
            root.nextShape.blocks.forEach((block) => {
                block.destroy()
            })
            root.nextShape.blocks = [] // Remove the stale refs
            root.activeShape = root.nextShape // Set this as the active shape now
        }
        console.log(`active shape: ${root.activeShape}`)
        
        // Create the next shape
        root.nextShape = createShape()

        let orientationIndex = 0 // Default orientation

        // Render active shape
        // For each block within the shape
        for (let i = 0; i < root.activeShape.orientations[orientationIndex].length; i++) {

            // Calculate the position to render each block at
            let xPos = root.activeShape.originPos.x + root.activeShape.orientations[orientationIndex][i].x
            let yPos = root.activeShape.originPos.y + root.activeShape.orientations[orientationIndex][i].y

            // Instantiate
            let blockComp = Qt.createComponent("Block.qml")
            let blockStyleComp = Qt.createComponent("BlockStyle.qml")
            let blockRef = blockComp.createObject(root.gameBoard, {
                xPos: xPos,
                yPos: yPos,
                size: root.blockSize,
                // Need to create a copy of the style so that when the shape is destroyed, we still hold the style data here.
                style: blockStyleComp.createObject(null, {
                    color: root.activeShape.style.color,
                    borderColor: root.activeShape.style.borderColor,
                })
            })

            // Add the block ref to the active shape
            root.activeShape.blocks.push(blockRef)
        }

        // Gameover if spawned block overlaps existing
        root.activeShape.blocks.forEach(block => {
            if (root.gameGrid[block.yPos][block.xPos] !== null) {
                gameOver()
                return
            }
        })


        // Render next shape
        // For each block within the shape
        for (let i = 0; i < root.nextShape.orientations[orientationIndex].length; i++) {

            let xPos = root.nextShape.originPos.x + root.nextShape.orientations[orientationIndex][i].x
            let yPos = root.nextShape.originPos.y + root.nextShape.orientations[orientationIndex][i].y

            // Instantiate
            let blockComp = Qt.createComponent("Block.qml")
            let blockStyleComp = Qt.createComponent("BlockStyle.qml")
            let blockRef = blockComp.createObject(root.nextShapeBoard, {
                xPos: xPos,
                yPos: yPos,
                size: root.blockSize,
                style: blockStyleComp.createObject(null, {
                    color: root.activeShape.style.color,
                    borderColor: root.activeShape.style.borderColor,
                })
            })

            // Add the block ref to the active shape
            root.nextShape.blocks.push(blockRef)
        }
    }


    property Timer clock: Timer {
        id: timer
        running: false
        triggeredOnStart: false
        interval: 1000
        repeat: true
        onTriggered: {
            console.log('tick')
            root.moveDown()
        }
    }


    function moveLeft() {
        // Check for out of bounds
        for (const block of root.activeShape.blocks) {
            if (block.xPos - 1 < 0) {
                console.log('hit right')
                return
            }

            // Check for collision with block
            if (root.gameGrid[block.yPos][block.xPos - 1] !== null) {
                console.log('hit block')
                return
            }
        }

        activeShape.originPos.x -= 1 // Move origin position left
        // Then perform actual movement
        for (let i = 0; i < activeShape.blocks.length; i++){
            // Move each block left by setting it's position to its origin + offset
            activeShape.blocks[i].xPos = activeShape.originPos.x + activeShape.orientations[activeShape.currentOrientation][i].x
        }
    }

    function moveRight() {
        // Check for out of bounds
        for (const block of root.activeShape.blocks) {
            if (block.xPos + 1 >= root.gridColumns) {
                console.log('hit right')
                return
            }

            // Check for collision with block
            if (root.gameGrid[block.yPos][block.xPos + 1] !== null) {
                console.log('hit block')
                return
            }
        }

        root.activeShape.originPos.x += 1 // Move origin position right
        // Then perform actual movement
        for (let i = 0; i < root.activeShape.blocks.length; i++){
            // Move each block right by setting it's position to its origin + offset
            root.activeShape.blocks[i].xPos = root.activeShape.originPos.x + root.activeShape.orientations[root.activeShape.currentOrientation][i].x
        }
    }

    function checkAndClearLines() {
        // How much to move down blocks by after line clears
        // + tells how many rows have been cleared
        let currentMoveDownAmount = 0

        root.printGrid()

        // For each row, starting at the bottom
        for (let y = root.gridRows - 1; y >= 0; y--) {
            console.log(`checking row ${y}`)
            // Assume the row is full
            let isFullRow = true

            // For each column in the row
            for (let x = 0; x < root.gridColumns; x++) {
                // If empty space found
                if (root.gameGrid[y][x] === null) {
                    isFullRow = false
                    // If the row needs to be moved down
                    if (currentMoveDownAmount > 0) {
                        // For each block in the row
                        // Move it down by the amount needed
                        root.printGrid()
                        console.log('row = ' + root.gameGrid[y])
                        for (let x = 0; x < root.gridColumns; x++) {
                            let block = root.gameGrid[y][x]
                            console.log(`looking at block: ${block}`)
                            // If the block space is empty, skip
                            if (block === null || block === 0) {
                                console.log('block skipped....')
                                continue
                            }
                            console.log(`original block: ${block}: ${block.yPos}, ${block.xPos}`)
                            root.gameGrid[block.yPos][block.xPos] = null // unset the previous position
                            block.yPos += currentMoveDownAmount // Move the block down
                            console.log(`moved down block: ${block.yPos}, ${block.xPos}`)
                            root.gameGrid[block.yPos][block.xPos] = block // set the new position
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
                for (let x = 0; x < root.gridColumns; x++) {
                    root.gameGrid[y][x].destroy() // Destory the block
                    root.gameGrid[y][x] = null // Unset it's position
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
        root.score += scoreChart[currentMoveDownAmount]
    }

    function moveDown() {
        // Check if movement is allowed
        for (const block of root.activeShape.blocks) {
            //console.log(`${block.yPos}`)
            // Lock shape if bottom of board is hit
            if (block.yPos + 1 >= root.gridRows) {
                console.log('hit bottom')
                // Lock Shape
                root.activeShape.blocks.forEach((block) => {
                    root.gameGrid[block.yPos][block.xPos] = block // Lock Block
                })
                checkAndClearLines()
                spawnShape()
                return
            }
            // Lock shape if another block is hit
            if (gameGrid[block.yPos + 1][block.xPos] !== null) {
                console.log('hit block')
                // Lock Shape
                activeShape.blocks.forEach((block) => {
                    gameGrid[block.yPos][block.xPos] = block // Lock Block
                })
                checkAndClearLines()
                spawnShape()
                return
            }
        }
        activeShape.originPos.y += 1 // Move origin position down
        // Then perform actual movement
        for (let i = 0; i < activeShape.blocks.length; i++){
            // Move each block down by setting it's position to its origin + offset
            activeShape.blocks[i].yPos = activeShape.originPos.y + activeShape.orientations[activeShape.currentOrientation][i].y
        }
    }

    function rotateRight() { 
        const previousOrientation = activeShape.currentOrientation
        activeShape.currentOrientation++
        // Reset to 0 if was at last index
        if (activeShape.currentOrientation >= activeShape.orientations.length) {
            activeShape.currentOrientation = 0
        }

        // New orientation
        let orientation = activeShape.orientations[activeShape.currentOrientation]

        // Check if block can be rotated
        for (let i = 0; i < activeShape.blocks.length; i++) {
            const x = activeShape.originPos.x + orientation[i].x
            const y = activeShape.originPos.y + orientation[i].y
            // If any of the blocks can't be rotated, cancel the rotate
            if (gameGrid[y][x] !== null) {
                root.currentOrientation = previousOrientation
                return
            }
        }

        // Rotate each block
        for (let i = 0; i < activeShape.blocks.length; i++) {
            // Apply the corresponding transform
            activeShape.blocks[i].xPos = activeShape.originPos.x + orientation[i].x
            activeShape.blocks[i].yPos = activeShape.originPos.y + orientation[i].y
        }
    }

    function rotateLeft() {

    }

}
