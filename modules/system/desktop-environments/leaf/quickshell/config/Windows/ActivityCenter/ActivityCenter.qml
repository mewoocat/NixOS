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
            AbsGrid.WidgetInstance {
                yPosition: 0
                xPosition: 0
                xSize: 2
                ySize: 2
                uid: "widget-1"
                state: null
                widgetDefinitionId: "weather-2x2"
            },
            AbsGrid.WidgetInstance {
                yPosition: 3
                xPosition: 0
                xSize: 3
                ySize: 3
                uid: "widget-2"
                state: null
                widgetDefinitionId: "calendar-3x3"
            },
            AbsGrid.WidgetInstance {
                yPosition: 0
                xPosition: 4
                xSize: 2
                ySize: 2
                uid: "widget-3"
                state: null
                widgetDefinitionId: "analog-clock-2x2"
            },
            AbsGrid.WidgetInstance {
                yPosition: 3
                xPosition: 3
                xSize: 2
                ySize: 2
                uid: "widget-4"
                state: null
                widgetDefinitionId: "notifications-6x6"
            }
        ]
        // I think something with how these are constructed makes the required properties not be loaded before accessed
        availableWidgetDefinitions: [
            Widgets.Weather {},
            Widgets.Calendar {},
            Widgets.AnalogClock {},
            Widgets.Notifications {}
        ]
    }
}

