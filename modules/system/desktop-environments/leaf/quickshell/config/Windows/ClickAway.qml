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
            color: "#00ff0000"
            MouseArea {
                id: area
                hoverEnabled: true
                anchors.fill: parent
                onClicked: () => {
                    // Close the most recent focused window
                    Root.State.focusStack[Root.State.focusStack.length - 1].closeWindow()
                }
            }
            // Allow clicks to pass through
            // Doesn't seem to be a way to do this *and* detect mouse clicks
            /*
            mask: Region {
                item: area
                intersection: Intersection.Subtract
            }
            */
        }
    }
}
