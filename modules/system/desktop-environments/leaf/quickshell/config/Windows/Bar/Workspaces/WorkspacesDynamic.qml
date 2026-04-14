pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Widgets
import qs as Root
import qs.Components.Controls as Ctrls
import qs.Services as Services
import "../"

WrapperMouseArea {
    id: root
    required property ShellScreen screen
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
            model: Services.Hyprland.workspaces.values.filter(w => w.monitor.name == root.screen.name)
            WsButton {
                id: workspaceButton
                required property HyprlandWorkspace modelData
                wsId: modelData.id
                wsObj: modelData
                text: modelData.name
                Layout.fillHeight: true
                implicitHeight: Root.State.barHeight
            }
        }

        BarButton {
            text: "+"
            inset: 10
            padding: 0
            onClicked: Hyprland.dispatch(`workspace emptynm`) // "Create" the next empty workspace
        }
    }
}

