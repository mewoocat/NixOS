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
    padding: 20

    content: AbsGrid.PanelGrid {
        id: panelGrid
        xSize: 8
        ySize: 6
        model: [
            AbsGrid.WidgetInstance {
                yPosition: 0
                xPosition: 0
                xSize: 2
                ySize: 2
                uid: "widget-1"
                state: null
                widgetDefinitionId: "weather-2x2"
            }
            /*
            AbsGrid.WidgetInstance {
                yPosition: 3
                xPosition: 3
                xSize: 3
                ySize: 3
                uid: "widget-2"
                state: null
                widgetDefinitionId: "calendar-3x3"
            }
            */
        ]
        availableWidgetDefinitions: [
            Widgets.Weather {
                //unitSize: panelGrid.unitSize

            }
            /*
            AbsGrid.WidgetDefinition {
                uid: "weather"
                name: "Weather"
                xSize: 2
                ySize: 2
                defaultState: null
                component: Widgets.Weather {}
            },
            AbsGrid.WidgetDefinition {
                uid: "calendar"
                name: "Calendar"
                xSize: 3
                ySize: 3
                defaultState: null
                component: Widgets.Calendar {}
            }
            */
        ]
    }
}

