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

    content: AbsGrid.PanelGrid {
        id: panelGrid
        xSize: 12
        ySize: 10
        model: Root.State.config.activityCenterWidgets
        onModelUpdated: (newInstances) => {
            Root.State.config.activityCenterWidgets = newInstances
            Root.State.configFileView.writeAdapter()
        }
    }
}

