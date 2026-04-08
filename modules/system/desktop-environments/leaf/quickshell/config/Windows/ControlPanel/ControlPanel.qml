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
    visible: Root.State.controlPanelVisibility
    focusable: false

    onToggleWindow: () => {
        Root.State.controlPanelVisibility = !Root.State.controlPanelVisibility
    } 
    onCloseWindow: () => {
        Root.State.controlPanelVisibility = false
        Root.State.controlPanelPage = "main"
    } 
    anchors {
        top: true
        right: true
    }

    content: Item {
        width: panelGrid.width
        height: panelGrid.height
        AbsGrid.PanelGrid {
            visible: Root.State.controlPanelPage == "main"
            id: panelGrid
            xSize: 4
            ySize: 6
            allowEditToggle: false
            onModelUpdated: (newModel) => model = newModel
            model: [
                Widgets.Network {
                    xPosition: 0
                    yPosition: 0
                },
                Widgets.ScreenCapture {
                    xPosition: 2
                    yPosition: 0
                },
                Widgets.NightLight {
                    xPosition: 3
                    yPosition: 0
                },
                Widgets.AudioAndBrightness {
                    xPosition: 0
                    yPosition: 4
                },
                Widgets.ExpandTest {
                    xPosition: 3
                    yPosition: 1
                }
            ]
        }
        /*
        Loader {
            visible: Root.State.controlPanelPageItem != null
            x: parent.mapFromItem(Root.State.controlPanelPageItem, 0, 0).x
            y: parent.mapFromItem(Root.State.controlPanelPageItem, 0, 0).y
            width: visible ? parent.width : 0//networkWidget.width
            height: visible ? parent.height : 0//networkWidget.height
            Behavior on height { PropertyAnimation { duration: 1000; easing.type: Easing.InOutQuint; } }
            Behavior on width { PropertyAnimation { duration: 1000; easing.type: Easing.InOutQuint; } }
            property Component component: Pages.Bluetooth {}
            sourceComponent: component
        }
        */
    }
}
