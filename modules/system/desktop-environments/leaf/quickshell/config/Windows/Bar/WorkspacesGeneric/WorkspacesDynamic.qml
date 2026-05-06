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
    hoverEnabled: true

    RowLayout {
        spacing: 0

        Repeater {
            id: wsRepeater
            // Only show workspaces for this screen
            model: WindowManager.windowsets
                .filter(w => {
                    return w.projection.screens.includes(root.screen)
                })
                .sort((a, b) => {
                    if (a.coordinates[1] > b.coordinates[1]) return 1
                    return -1
                })
            WsButton {
                id: workspaceButton
                required property Windowset modelData
                required property int index
                ws: modelData
                isLast: index + 1 === wsRepeater.model.length
                Layout.fillHeight: true
                implicitHeight: Root.State.barHeight
            }
        }
    }
}

