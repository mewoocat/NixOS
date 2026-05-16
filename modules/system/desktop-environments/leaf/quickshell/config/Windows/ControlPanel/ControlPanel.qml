import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick
import QtQuick.Controls
import qs as Root
import qs.Components.Shared as Shared
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid

Shared.PanelWindow {
    id: root
    name: "controlPanel"
    visible: Root.State.controlPanelActive

    onCloseRequested: () => {
        Root.State.controlPanelActive = false
    }

    anchors {
        top: true
        right: true
    }

    content: AbsGrid.PanelGrid {
        id: panelGrid
        xSize: 4
        ySize: 5
        allowEditToggle: false
        model: [
            {
                uid: "Components/Widgets/Network.qml",
                xPosition: 0,
                yPosition: 0
            },
            {
                uid: "Components/Widgets/ScreenCapture.qml",
                xPosition: 3,
                yPosition: 1
            },
            {
                uid: "Components/Widgets/NightLight.qml",
                xPosition: 3,
                yPosition: 0
            },
            {
                uid: "Components/Widgets/ColorMode.qml",
                xPosition: 3,
                yPosition: 2
            },
            {
                uid: "Components/Widgets/PowerProfile.qml",
                xPosition: 0,
                yPosition: 2
            },
            {
                uid: "Components/Widgets/AudioAndBrightness.qml",
                xPosition: 0,
                yPosition: 3
            }
        ]
    }
}
