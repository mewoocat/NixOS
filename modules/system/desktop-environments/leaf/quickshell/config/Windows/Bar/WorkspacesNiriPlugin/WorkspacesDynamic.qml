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

            model: Services.Niri.plugin.workspaces
            WsButtonNiriPlugin {
                id: workspaceButton
                required property var modelData
                required property var index
                visible: modelData.output === root.screen.name
                wsIndex: index
                ws: modelData
                Layout.fillHeight: true
                implicitHeight: Root.State.barHeight
            }
        }
    }
}

