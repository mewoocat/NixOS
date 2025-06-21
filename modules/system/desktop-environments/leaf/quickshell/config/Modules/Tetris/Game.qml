import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import "./Shapes"
import "../Common" as Common

FocusScope {
    
    focus: true
    Keys.onPressed: (event) => {
        console.log('hi')
        if (event.key == Qt.Key_A) { Tetris.activeShape.moveLeft() }
        if (event.key == Qt.Key_D) { Tetris.activeShape.moveRight() }
        if (event.key == Qt.Key_S) { Tetris.activeShape.moveDown() }
        if (event.key == Qt.Key_Space) { Tetris.activeShape.rotateRight() }
    }
    ColumnLayout {

        // Main game board
        Rectangle {
            id: gameBoard
            color: "black"
            implicitWidth: Tetris.blockSize * Tetris.gridColumns
            implicitHeight: Tetris.blockSize * Tetris.gridRows

            Component.onCompleted: Tetris.gameBoard = gameBoard

        }
        
        // TODO: Scoreboard and next shape goes here
        Common.NormalButton {text: "start"; leftClick: () => {
            console.log('click')
            Tetris.start()
        }}
    }
}
