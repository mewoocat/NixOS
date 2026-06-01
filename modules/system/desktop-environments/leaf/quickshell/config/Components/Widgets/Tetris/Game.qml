pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.Components.Controls as Ctrls

Rectangle {
    id: root
    anchors.fill: parent
    color: "red"

    property int blockSize: 14

    property Tetris tetris: Tetris {
        blockSize: blockSize
    }

    Rectangle {
        id: controlBoard
        anchors.centerIn: parent
        implicitHeight: gameBoard.implicitHeight
        implicitWidth: gameBoard.implicitWidth + sidePanel.implicitWidth
        color: "transparent"
        onVisibleChanged: root.tetris.pause()

        onFocusChanged: console.log(`controlBoard focus changed to ${focus}`)
        Keys.onPressed: (event) => {
            console.log(`key event root`)
            if (root.tetris.isRunning) {
                if (event.key == Qt.Key_A) { root.tetris.moveLeft() }
                if (event.key == Qt.Key_D) { root.tetris.moveRight() }
                if (event.key == Qt.Key_S) { root.tetris.moveDown() }
                if (event.key == Qt.Key_L) { root.tetris.rotateRight() }
            }
        }
        
        Rectangle {
            id: gameBoard
            border.width: 1
            border.color: controlBoard.focus ? "deepskyblue" : "grey"
            color: "transparent"
            implicitWidth: root.tetris.blockSize * root.tetris.gridColumns
            implicitHeight: root.tetris.blockSize * root.tetris.gridRows
            Component.onCompleted: root.tetris.gameBoard = gameBoard
        }

        Rectangle {
            id: pauseOverlay
            visible: root.tetris.isPaused
            anchors.fill: gameBoard
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
            anchors.left: gameBoard.right
            implicitHeight: gameBoard.height
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
                        text: `${root.tetris.score}`
                    }
                }
                Button {
                    text: !root.tetris.isRunning || root.tetris.isPaused ? "start" : "pause" ;
                    onClicked: () => {
                        if (!root.tetris.isRunning || root.tetris.isPaused) {
                            root.tetris.start()
                            controlBoard.forceActiveFocus()
                            //root.focus = true // idk why setting this doesn't give root the active focus
                        }
                        else {
                            root.tetris.pause()
                            controlBoard.focus = false
                        }
                    }
                }
                Button {
                    text: "reset"
                    onClicked: () => root.tetris.reset()
                }
            }

            // Next shape display
            Rectangle {
                anchors.bottomMargin: 6
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                id: nextShapeBoard
                color: "black"
                implicitWidth: root.tetris.blockSize * 4
                implicitHeight: root.tetris.blockSize * 4

                Component.onCompleted: root.tetris.nextShapeBoard = nextShapeBoard
            }
        }
    }
}
