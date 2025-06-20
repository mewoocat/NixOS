import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "./Shapes"
import "../Common" as Common

// Wiget container
WrapperItem {
    id: root

    property int gridRows: 20
    property int gridColumns: 10
    property int blockSize: 20
    property list<BlockDef> blocks: [] // Holds all blocks on the board by definition
    // 2D array that holds gameboard state
    // Each item is undefined (empty), or a ref to the block obj
    //property list<list<int>> gameGrid: [[]] // Stupid syntax error
    property var gameGrid2: {
        let grid = new Array(root.gridRows)
        return grid
    }
    property var gameGrid: {
        let grid = new Array(root.gridRows)
        // Initialize with nulls
            // I could have sworn that you can just insert into whatever index you want 
            // but it's throwing a type error if I do that
        for (let x = 0; x < root.gridRows; x++) {
            grid[x] = new Array(root.gridColumns)
            for (let y = 0; y < root.gridColumns; y++) {
                grid[x][y] = false
            }
        }
        console.log(`grid: ${grid}`)
        return grid
    }

    // Inline component that defines how to create a shape
    /*
    component ShapeDefinition: QtObject {
        required property 
        required property int yTransform
    }
    */

    property Shape activeShape: null



    ColumnLayout {

        Rectangle {
            id: gameBoard
            color:"green"
            implicitWidth: root.blockSize * root.gridColumns
            implicitHeight: root.blockSize * root.gridRows

            function addShape() {
                console.log('adding shape')
                //console.log(root.gameGrid)
                //const shapeComponent = "O.qml"
                // Apparently need to provide the full relative path, doesn't seem to inherit imported paths
                let component = Qt.createComponent("Shapes/O.qml")
                root.activeShape = component.createObject(null, {})
                console.log(`active shape: ${root.activeShape}`)
                root.activeShape.blockDefs.forEach((def) => {
                    console.log(`block: ${def.xPos}, ${def.yPos}`)
                    //root.gameGrid[block.xPos][block.yPos] = block
                    //root.blocks.push(def)

                    let blockComp = Qt.createComponent("Block.qml")
                    let blockRef = blockComp.createObject(gameBoard, {
                        xPos: def.xPos,
                        yPos: def.yPos,
                        style: def.style
                    })

                    root.activeShape.blocks.push(blockRef)
                })
                
                // Ok this works to create the shape
                //root.activeShape = shapeComp.createObject(gameBoard, {})
            }
            Component.onCompleted: addShape()

            Timer {
                id: timer
                running: true
                triggeredOnStart: false
                interval: 3000
                repeat: true
                onTriggered: {
                    //root.activeShape.moveDown()
                    //console.log(root.gameGrid)
                    //gameBoard.addShape()
                }
            }

            // Render all active blocks

            /*
            Repeater {
                model: root.blocks
                // Render the block
                Block {
                    id: block
                    required property BlockDef modelData
                    xPos: modelData.xPos
                    yPos: modelData.yPos
                    style: modelData.style
                    Component.onCompleted: {
                        console.log(`block loaded`)
                        // Might need to do a check on the BlockDef and see if it's apart of the current shape
                        // It might be possible for blocks not apart of the active shape to get recreated and thus 
                        // added to the block refs of the active shape
                        root.activeShape.blocks.push(block) // add the block ref to the current shape
                    }
                }
                WrapperRectangle {
                    //color: "grey"
                    margin: 2
                    required property Block modelData
                    Layout.row: modelData.xPos
                    Layout.column: modelData.yPos
                    //children: [ Block { xPos: 0; yPos: 0; style: "red"}]
                    children: [ modelData ]
                }
                
            }
            */

            /*
            children: {
                let blocks = root.gameGrid.join()
                console.log(`block list: ${blocks}`)
                return blocks
            }
            */
            /*
            children: [
                Block { xPos: 0; yPos: 0; style: "red"}
            ]
            */
            
            /*
            // Each row
            Repeater {
                id: rows
                model: ScriptModel {
                    values: root.gameGrid
                }

                // Render the block
                WrapperItem {
                    required property Block modelData
                    //Component.onCompleted: console.log(`rendering block... ${modelData}`)
                    children: [ modelData ]
                }
                // Each column
                Repeater {
                    id: columns
                    //required property list<Block> modelData
                    required property var modelData
                    model: ScriptModel {
                        values: columns.modelData
                    }
                    // Render the block
                    WrapperItem {
                        required property Block modelData
                        //Component.onCompleted: console.log(`rendering block... ${modelData}`)
                        children: [ modelData ]
                    }
                }
            }
            */

            //children: root.blocks
        }

        Common.NormalButton {text: "start"; leftClick: gameBoard.addShape2}
    }
} 

