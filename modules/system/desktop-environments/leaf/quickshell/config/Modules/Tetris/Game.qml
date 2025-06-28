import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "./Shapes"
import "../Common" as Common

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
    Item {
        anchors.centerIn: parent
        implicitHeight: gameBoard.height
        implicitWidth: gameBoard.width + sidePanel.width

        // Main game board
        WrapperRectangle {
            id: gameBox
            color: palette.accent
            margin: 2
            topLeftRadius: 2
            bottomLeftRadius: 2
            Rectangle {
                id: gameBoard
                color: "black"
                implicitWidth: Tetris.blockSize * Tetris.gridColumns
                implicitHeight: Tetris.blockSize * Tetris.gridRows

                Component.onCompleted: Tetris.gameBoard = gameBoard

            }
        }

        WrapperRectangle {
            anchors.left: gameBox.right
            implicitHeight: gameBox.height
            color: palette.accent

            margin: 2
            topRightRadius: 2
            bottomRightRadius: 2
        Rectangle {
            id: sidePanel
            //Layout.fillHeight: true
            //Layout.fillWidth: true
            color: palette.base
            implicitWidth: 92

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
                Button {
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

                Button {
                    text: "reset"
                    onClicked: Tetris.reset
                }
            }

            // Next shape display
            Rectangle {
                anchors.bottomMargin: 6
                /*
                border {
                    color: "red"
                }
                */
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
}
