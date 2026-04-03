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
    implicitWidth: content.width
    implicitHeight: content.height


    // Something weird's going on here
    content: AbsGrid.PanelGrid {
        xSize: 8
        ySize: 6
        model: [
            AbsGrid.WidgetInstance {
                yPosition: 0
                xPosition: 0
                xSize: 1
                ySize: 1
                uid: "widget-1"
                state: null
                widgetDefinitionId: "weather"
            },
            AbsGrid.WidgetInstance {
                yPosition: 3
                xPosition: 3
                xSize: 2
                ySize: 2
                uid: "widget-2"
                state: null
                widgetDefinitionId: "calendar"
            }
        ]
        availableWidgetDefinitions: [
            AbsGrid.WidgetDefinition {
                uid: "weather"
                name: "Weather"
                xSize: 1
                ySize: 1
                defaultState: null
                component: Widgets.Weather {}
            },
            AbsGrid.WidgetDefinition {
                uid: "calendar"
                name: "Calendar"
                xSize: 2
                ySize: 2
                defaultState: null
                component: Widgets.Calendar {}
            }
        ]
    }
}

