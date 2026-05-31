pragma Singleton

import Quickshell
import QtQuick

Singleton {
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
        if (!Tetris.isPaused) {
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
                // Need to create a copy of the style so that when the shape is destroyed, we still hold
                // the style data here.
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
                style: blockStyleComp.createObject(null, {
                    color: root.activeShape.style.color,
                    borderColor: root.activeShape.style.borderColor,
                })
            })

            // Add the block ref to the active shape
            root.nextShape.blocks.push(blockRef)
        }
    }


    Timer {
        id: timer
        running: false
        triggeredOnStart: false
        interval: 1000
        repeat: true
        onTriggered: {
            console.log('tick')
            root.activeShape.moveDown()
        }
    }

}
