import Quickshell
import QtQuick
import qs as Root

Scope {
    Variants {
        model: Quickshell.screens 
        // qmllint disable uncreatable-type
        PanelWindow {
            id: window
            visible: Root.State.clickAwayVisible
            required property ShellScreen modelData
            screen: modelData
            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }
            color: "#33ff0000"
            MouseArea {
                id: area
                hoverEnabled: true
                anchors.fill: parent
                onClicked: () => {
                    console.log(`click`)
                    //const poppedWindow = Root.State.focusStack.pop()
                    Root.State.focusStack[Root.State.focusStack.length - 1].closeWindow()
                }
            }
            // Allow clicks to pass through
            /*
            mask: Region {
                item: area
                intersection: Intersection.Subtract
            }
            */
        }
    }
}
