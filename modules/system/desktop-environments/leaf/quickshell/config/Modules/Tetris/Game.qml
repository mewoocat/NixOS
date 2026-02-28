pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "./Shapes"
import "../Common" as Common
import "../Leaf" as Leaf

FocusScope {
    anchors.fill: parent
    
    focus: true
    Keys.onPressed: (event) => {
        if (Tetris.isRunning) {
            if (event.key == Qt.Key_A) { Tetris.activeShape.moveLeft() }
            if (event.key == Qt.Key_D) { Tetris.activeShape.moveRight() }
            if (event.key == Qt.Key_S) { Tetris.activeShape.moveDown() }
            if (event.key == Qt.Key_L) { Tetris.activeShape.rotateRight() }
        }
    }
    Rectangle {
        anchors.centerIn: parent
        implicitHeight: gamePanel.implicitHeight
        implicitWidth: gamePanel.implicitWidth + sidePanel.implicitWidth
        color: "transparent"
        
        // Main game board
        // Keep in mind that a border on a wrapper rectangle will be drawn outside the area of the child
        WrapperRectangle {
            id: gamePanel
            border.width: 1
            border.color: "white"
            color: "transparent"
            Rectangle {
                id: gameBoard
                color: "transparent"
                implicitWidth: Tetris.blockSize * Tetris.gridColumns
                implicitHeight: Tetris.blockSize * Tetris.gridRows
                Component.onCompleted: Tetris.gameBoard = gameBoard
            }
        }

        Rectangle {
            id: sidePanel
            anchors.left: gamePanel.right
            implicitHeight: gamePanel.height
            topRightRadius: 2
            bottomRightRadius: 2
            color: "transparent"
            implicitWidth: 80
            border.width: 1
            border.color: "white"

            ColumnLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    color: palette.text
                    text: `score`
                } 
                WrapperRectangle { 
                    color: "black"
                    margin: 8
                    implicitWidth: parent.width
                    Text {
                        color: palette.text
                        text: `${Tetris.score}`
                    } 
                }
                Leaf.Button {
                    text: !Tetris.isRunning || Tetris.isPaused ? "start" : "pause" ;
                    onClicked: () => {
                        if (!Tetris.isRunning || Tetris.isPaused) {
                            Tetris.start()
                        }
                        else {
                            Tetris.pause()
                        }
                    }
                }

                Leaf.Button {
                    text: "reset"
                    onClicked: Tetris.reset
                }
            }

            // Next shape display
            Rectangle {
                anchors.bottomMargin: 6
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                id: nextShapeBoard
                color: "black"
                implicitWidth: Tetris.blockSize * 4
                implicitHeight: Tetris.blockSize * 4

                Component.onCompleted: Tetris.nextShapeBoard = nextShapeBoard

            }
        }
    }
}
