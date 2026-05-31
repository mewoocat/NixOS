pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.Components.Controls as Ctrls

Item {
    id: root
    anchors.fill: parent
    
    Rectangle {
        id: controlBoard
        anchors.centerIn: parent
        implicitHeight: gamePanel.implicitHeight
        implicitWidth: gamePanel.implicitWidth + sidePanel.implicitWidth
        color: "transparent"
        focus: true // This item needs focus to handle keyboard inputs
        onVisibleChanged: Tetris.pause()

        onFocusChanged: console.log(`controlBoard focus changed to ${focus}`)
        Keys.onPressed: (event) => {
            console.log(`key event root`)
            if (Tetris.isRunning) {
                if (event.key == Qt.Key_A) { Tetris.activeShape.moveLeft() }
                if (event.key == Qt.Key_D) { Tetris.activeShape.moveRight() }
                if (event.key == Qt.Key_S) { Tetris.activeShape.moveDown() }
                if (event.key == Qt.Key_L) { Tetris.activeShape.rotateRight() }
            }
        }
        
        // Main game board
        // Keep in mind that a border on a wrapper rectangle will be drawn outside the area of the child
        WrapperRectangle {
            id: gamePanel
            border.width: 1
            border.color: controlBoard.focus ? "deepskyblue" : "grey"
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
            id: pauseOverlay
            visible: Tetris.isPaused
            anchors.fill: gamePanel
            color: "transparent"
            WrapperRectangle {
                anchors.centerIn: parent
                margin: 2
                Text {
                    text: "Paused"
                }
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
            border.color: controlBoard.focus ? "deepskyblue" : "grey"

            ColumnLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    color: "white"
                    text: `score`
                } 
                WrapperRectangle { 
                    color: "black"
                    margin: 8
                    implicitWidth: parent.width
                    Text {
                        color: "white"
                        text: `${Tetris.score}`
                    }
                }
                
                Button {
                    text: !Tetris.isRunning || Tetris.isPaused ? "start" : "pause" ;
                    onClicked: () => {
                        if (!Tetris.isRunning || Tetris.isPaused) {
                            Tetris.start()
                            controlBoard.forceActiveFocus()
                            //root.focus = true // idk why setting this doesn't give root the active focus
                        }
                        else {
                            Tetris.pause()
                            controlBoard.focus = false
                        }
                    }
                }

                Button {
                    text: "reset"
                    onClicked: () => Tetris.reset()
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
