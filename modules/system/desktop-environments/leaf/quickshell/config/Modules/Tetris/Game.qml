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
        if (event.key == Qt.Key_A) { Tetris.activeShape.moveLeft() }
        if (event.key == Qt.Key_D) { Tetris.activeShape.moveRight() }
        if (event.key == Qt.Key_S) { Tetris.activeShape.moveDown() }
        if (event.key == Qt.Key_Space) { Tetris.activeShape.rotateRight() }
    }
    RowLayout {
    anchors.centerIn: parent
    anchors.fill: parent

        // Main game board
        Rectangle {
            id: gameBoard
            color: "black"
            implicitWidth: Tetris.blockSize * Tetris.gridColumns
            implicitHeight: Tetris.blockSize * Tetris.gridRows

            Component.onCompleted: Tetris.gameBoard = gameBoard

        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true

            ColumnLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    color: palette.text
                    text: `Score: ${Tetris.score}`
                } 
                Common.NormalButton {
                    text: !Tetris.isRunning || Tetris.isPaused ? "start" : "pause" ;
                    leftClick: () => {
                        if (!Tetris.isRunning || Tetris.isPaused) {
                            Tetris.start()
                        }
                        else {
                            Tetris.pause()
                        }
                    }
                }
            }

            // Next shape display
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                id: nextShapeBoard
                anchors.bottom: parent.bottom
                color: "black"
                implicitWidth: Tetris.blockSize * 4
                implicitHeight: Tetris.blockSize * 4

                Component.onCompleted: Tetris.nextShapeBoard = nextShapeBoard

            }
        }
    }
}
