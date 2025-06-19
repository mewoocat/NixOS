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

    //property list<list<int>> gameGrid: [[]] // Stupid syntax error
    property var gameGrid: [[]] // 2D array that holds gameboard state
    property int gridWidth: 10
    property int gridHeight: 20
    //property list<QtObject> blocks: [] // Holds all blocks on the board
    property int blockSize: 20

    // Inline component that defines how to create a shape
    /*
    component ShapeDefinition: QtObject {
        required property 
        required property int yTransform
    }
    */

    property Shape activeShape: null

    GridLayout {
        id: gameBoard
        
        Common.NormalButton {text: "start"; leftClick: gameBoard.addShape}
        O {}

        function addShape() {
            console.log('adding shape')
            const shapeComponent = "O"
            const component = Qt.createComponent(shapeComponent)
            root.activeShape = component.createObject(gameBoard, {})
        }
        //Component.onCompleted: addShape()

        Timer {
            id: timer
            triggeredOnStart: true
            interval: 1000
            repeat: true
            onTriggered: {
                console.log('moving down')
                //root.activeShape.moveDown()
            }
        }

        rows: root.gridWidth 
        columns: root.gridHeight

        // Render all active blocks
        // Each row
        Repeater {
            id: rows
            model: ScriptModel {
                values: root.gameGrid
            }
            // Each column
            Repeater {
                id: columns
                required property list<Block> modelData
                model: ScriptModel {
                    values: [...columns.modelData]
                }
                // Render the block
                WrapperItem {
                    required property Block modelData
                    children: [ modelData ]
                }
            }
        }

        //children: root.blocks
    }
} 

