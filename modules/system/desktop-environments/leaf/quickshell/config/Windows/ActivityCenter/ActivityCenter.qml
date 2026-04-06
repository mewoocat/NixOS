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
        //onModelUpdated: (newModel) => model = newModel
        //onModelUpdated: (newModel) => console.debug(`new model now is ${JSON.stringify(newModel, null, 4)}`)
        /*
        onWidgetJsonChanged: () => {
            console.debug(`widgetJson changed to ${JSON.stringify(widgetJson, null, 4)}`)
            Root.State.config.activityCenterWidgets = widgetJson
            Root.State.configFileView.writeAdapter()
        }
        */
        widgetJson: Root.State.config.activityCenterWidgets
        onWidgetJsonUpdated: (newJson) => {
            Root.State.config.activityCenterWidgets = newJson
            Root.State.configFileView.writeAdapter()
        }
    }
}

