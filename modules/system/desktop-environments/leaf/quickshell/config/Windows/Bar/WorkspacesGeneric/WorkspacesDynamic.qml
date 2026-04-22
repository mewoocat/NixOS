pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.WindowManager
import Quickshell.Widgets
import qs as Root
import qs.Components.Controls as Ctrls
import qs.Services as Services
import "../"

WrapperMouseArea {
    id: root
    required property ShellScreen screen
    property var popup: Workspaces {}
    hoverEnabled: true
    onHoveredChanged: {
        if (containsMouse) {
            popupCloseDelay.running = false
            Root.State.isWorkspaceWidgetHovered = true
        }
        else {
            popupCloseDelay.running = true
        }
    }
    Timer {
        id: popupCloseDelay
        interval: 200
        onTriggered: () => {
            Root.State.isWorkspaceWidgetHovered = false
        }
        running: false
    }

    RowLayout {
        spacing: 0

        Repeater {
            // Only show workspaces for this screen
            model: WindowManager.windowsets
                .filter(w => w.id) // Only account for workspaces with an id
                .filter(w => {
                    console.debug(`windowset | id: ${w.id} | name: ${w.name}`)
                    return w.projection.screens.includes(root.screen)
                })
                /*
                .sort((a, b) => {
                    if (parseInt(a.id) > parseInt(b.id)) { return 1 }
                    return -1
                })
                */
            WsButton {
                id: workspaceButton
                required property Windowset modelData
                ws: modelData
                Layout.fillHeight: true
                implicitHeight: Root.State.barHeight
            }

            /*
            model: Services.Niri.plugin.workspaces
            WsButtonNiriPlugin {
                id: workspaceButton
                required property var modelData
                ws: modelData
                Layout.fillHeight: true
                implicitHeight: Root.State.barHeight
            }
            */
        }
    }
}

