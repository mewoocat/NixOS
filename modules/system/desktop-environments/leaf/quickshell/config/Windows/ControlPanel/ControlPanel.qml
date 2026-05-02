import Quickshell.Widgets
import QtQuick
import QtQuick.Controls
import qs as Root
import qs.Components.Shared as Shared
import "./Pages" as Pages
import "./Widgets" as Widgets
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid

Shared.PanelWindow {
    id: root
    name: "controlPanel"
    visible: Root.State.controlPanelActive
    focusable: false

    anchors {
        top: true
        right: true
    }

    content: AbsGrid.PanelGrid {
        id: panelGrid
        xSize: 4
        ySize: 6
        allowEditToggle: false
        model: [
            {
                uid: "Windows/ControlPanel/Widgets/Network.qml",
                xPosition: 0,
                yPosition: 0
            },
            {
                uid: "Windows/ControlPanel/Widgets/ScreenCapture.qml",
                xPosition: 2,
                yPosition: 0
            },
            {
                uid: "Windows/ControlPanel/Widgets/NightLight.qml",
                xPosition: 3,
                yPosition: 0
            },
            {
                uid: "Windows/ControlPanel/Widgets/AudioAndBrightness.qml",
                xPosition: 0,
                yPosition: 4
            }
        ]
    }
}
