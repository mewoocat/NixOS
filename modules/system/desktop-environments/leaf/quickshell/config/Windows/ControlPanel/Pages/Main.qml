import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire
import qs as Root
import qs.Services as Services
import qs.Components.Controls as Ctrls
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid
import "../Widgets" as Widgets

AbsGrid.PanelGrid {

    id: panelGrid
    xSize: 4
    ySize: 6
    onModelUpdated: (newModel) => model = newModel
    model: [
        AbsGrid.WidgetInstance {
            yPosition: 0
            xPosition: 0
            xSize: 2
            ySize: 2
            uid: "widget-1"
            state: null
            widgetDefinitionId: "network-2x2"
            widgetDefinition: Widgets.Network {}
        },
        AbsGrid.WidgetInstance {
            yPosition: 0
            xPosition: 2
            xSize: 1
            ySize: 1
            uid: "widget-2"
            state: null
            widgetDefinitionId: "network-1x1"
            widgetDefinition: Widgets.ScreenCapture {}
        },
        AbsGrid.WidgetInstance {
            yPosition: 0
            xPosition: 3
            xSize: 1
            ySize: 1
            uid: "widget-2"
            state: null
            widgetDefinitionId: "network-1x1"
            widgetDefinition: Widgets.ScreenCapture {}
        },
        AbsGrid.WidgetInstance {
            yPosition: 1
            xPosition: 2
            xSize: 1
            ySize: 1
            uid: "widget-2"
            state: null
            widgetDefinitionId: "network-1x1"
            widgetDefinition: Widgets.ScreenCapture {}
        },
        AbsGrid.WidgetInstance {
            yPosition: 1
            xPosition: 3
            xSize: 1
            ySize: 1
            uid: "widget-2"
            state: null
            widgetDefinitionId: "network-1x1"
            widgetDefinition: Widgets.ScreenCapture {}
        }
    ]
}
