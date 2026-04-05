pragma ComponentBehavior: Bound

import QtQuick
import qs as Root
import qs.Components.Widgets as Widgets
import qs.Components.Widgets.Tetris as Tetris
import qs.Components.Shared as Shared
import qs.Modules.Leaf as Leaf

import qs.Components.Shared.AbsoluteDragGrid as AbsGrid

Shared.PanelWindow {
    onToggleWindow: () => {
        Root.State.activityCenterVisibility = !Root.State.activityCenterVisibility
    } 
    onCloseWindow: () => {
        Root.State.activityCenterVisibility = false
    } 
    //id: window
    name: "activityCenter"
    visible: Root.State.activityCenterVisibility
    anchors {
        top: true
    }
    padding: Root.State.windowPadding
    implicitHeight: panelGrid.maxHeight // Need to set PanelWindow size to largest possible or else resizing with jitter

    content: AbsGrid.PanelGrid {
        id: panelGrid
        xSize: 12
        ySize: 10
        onModelUpdated: (newModel) => model = newModel
        model: [
            Widgets.Weather {
                xPosition: 0
                yPosition: 0
            },
            Widgets.AnalogClock {
                xPosition: 2
                yPosition: 0
            },
            Widgets.Notifications {
                xPosition: 0
                yPosition: 2
            },
            Widgets.Calendar {
                xPosition: 6
                yPosition: 0
            }
        ]
    }
}

