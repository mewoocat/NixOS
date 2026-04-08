pragma ComponentBehavior: Bound

import QtQuick
import qs as Root
import qs.Components.Shared as Shared

import qs.Components.Shared.AbsoluteDragGrid as AbsGrid

Shared.PanelWindow {
    onToggleWindow: () => {
        Root.State.activityCenterVisibility = !Root.State.activityCenterVisibility
    } 
    onCloseWindow: () => {
        Root.State.activityCenterVisibility = false
    } 
    name: "activityCenter"
    visible: Root.State.activityCenterVisibility
    anchors {
        top: true
    }
    implicitHeight: panelGrid.maxHeight // Need to set PanelWindow size to largest possible or else resizing with jitter

    content: AbsGrid.PanelGrid {
        id: panelGrid
        xSize: 12
        ySize: 10
        widgetJson: Root.State.config.activityCenterWidgets
        onWidgetJsonUpdated: (newJson) => {
            Root.State.config.activityCenterWidgets = newJson
            Root.State.configFileView.writeAdapter()
        }
    }
}

