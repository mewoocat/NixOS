import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.UPower
import Quickshell.Services.Pipewire

import qs.Modules.Leaf as Leaf // Deprecated

import qs as Root
import qs.Services as Services
import qs.Components.Controls as Ctrls
import qs.Components.Shared.AbsoluteDragGrid as AbsGrid
//import qs.Components.Widgets as Widgets
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
        }
    ]
}
