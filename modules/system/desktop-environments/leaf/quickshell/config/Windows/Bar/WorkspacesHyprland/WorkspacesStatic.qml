pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Widgets
import qs as Root
import qs.Components.Controls as Ctrls
import qs.Services as Services

WrapperMouseArea {
    id: mouseArea
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

    RowLayout {
        id: root
        property int numWorkspaces: 10
        property int padding: 4

        spacing: 0

        Timer {
            id: popupCloseDelay
            interval: 200
            onTriggered: () => {
                Root.State.isWorkspaceWidgetHovered = false
            }
            running: false
        }

        Repeater {
            model: root.numWorkspaces
            WsButton {
                id: workspaceButton
                required property int modelData
                wsId: modelData + 1
                Layout.fillHeight: true
                implicitHeight: Root.State.barHeight
                text: modelData + 1
            }
        }
    }
}

