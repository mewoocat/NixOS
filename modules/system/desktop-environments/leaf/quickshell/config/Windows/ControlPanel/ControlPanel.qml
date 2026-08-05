import Quickshell
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
        property var thing: AbsGrid.WidgetInstance {
            uid: "Components/Widgets/Network.qml"
            xPosition: 0
            yPosition: 0
        }
        /*
        model: ScriptModel {
            values: [
                panelGrid.thing
            ]
        }
        */
        model: [
            //Item {}
            AbsGrid.WidgetInstance {
                uid: "Components/Widgets/Network.qml"
                xPosition: 0
                yPosition: 0
            },
            AbsGrid.WidgetInstance {
                uid: "Components/Widgets/ScreenCapture.qml"
                xPosition: 3
                yPosition: 1
            },
            AbsGrid.WidgetInstance {
                uid: "Components/Widgets/NightLight.qml"
                xPosition: 3
                yPosition: 0
            },
            AbsGrid.WidgetInstance {
                uid: "Components/Widgets/ColorMode.qml"
                xPosition: 3
                yPosition: 2
            },
            AbsGrid.WidgetInstance {
                uid: "Components/Widgets/PowerProfile.qml"
                xPosition: 0
                yPosition: 2
            },
            AbsGrid.WidgetInstance {
                uid: "Components/Widgets/AudioAndBrightness.qml"
                xPosition: 0
                yPosition: 3
            }
        ]

    }
}
