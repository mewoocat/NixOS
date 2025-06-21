pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    property int gridRows: 20
    property int gridColumns: 10
    property int blockSize: 20

    property Rectangle gameBoard: null // Ref to gameBoard
    property Shape activeShape: null // Player controlled shape
    property list<BlockDef> blocks: [] // All blocks on the board by definition

    // 2D array that holds gameboard state
    // Each item is undefined (empty), or a ref to the block obj
    //property list<list<int>> gameGrid: [[]] // Stupid syntax error
    property var gameGrid: {
        let grid = new Array(root.gridRows)
        // Initialize with nulls
            // I could have sworn that you can just insert into whatever index you want 
            // but it's throwing a type error if I do that
        for (let x = 0; x < root.gridColumns; x++) {
            grid[x] = new Array(root.gridColumns)
            for (let y = 0; y < root.gridRows; y++) {
                grid[x][y] = null
            }
        }
        console.log(`grid: ${grid}`)
        return grid
    }


    function start() {
        console.log(`Starting tetris state singleton`)
        root.addShape()
        timer.running = true
    }

    function addShape() {
        console.log('adding shape')
        // Todo: add random shape picker here
        const shapeComponent = "Shapes/O.qml"
        // Apparently need to provide the full relative path, doesn't seem to inherit imported paths
        let component = Qt.createComponent(shapeComponent)
        root.activeShape = component.createObject(null, {})

        console.log(`active shape: ${State.activeShape}`)

        // For each block definition within the shape
        root.activeShape.blockDefs.forEach((def) => {
            // Instantiate
            let blockComp = Qt.createComponent("Block.qml")
            let blockRef = blockComp.createObject(root.gameBoard, {
                xPos: def.xPos,
                yPos: def.yPos,
                style: def.style
            })

            // Add the block ref to the active shape
            root.activeShape.blocks.push(blockRef)
        })     
    }

    Timer {
        id: timer
        running: false
        triggeredOnStart: false
        interval: 1000
        repeat: true
        onTriggered: {
            root.activeShape.moveDown()
        }
    }

}
