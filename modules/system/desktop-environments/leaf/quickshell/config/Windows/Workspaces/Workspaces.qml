pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs as Root
import qs.Modules.Leaf as Leaf

Leaf.FullscreenWindow {
    id: root
    toggleWindow: () => {
        Root.State.workspacesVisibility = !Root.State.workspacesVisibility
    } 
    closeWindow: () => {
        Root.State.workspacesVisibility = false
    } 
    name: "workspaces"
    visible: Root.State.workspacesVisibility
    implicitWidth: content.width
    implicitHeight: content.height
    content: MouseArea {
        id: padding
        anchors.fill: parent
        onClicked: () => root.closeWindow()
        enabled: true
        hoverEnabled: true
        GridLayout {
            id: grid
            anchors.centerIn: parent
            // Assuming a max of 10 workspaces
            rows: 3
            columns: 4
            rowSpacing: 24
            columnSpacing: 24
            Repeater {
                model: 10
                Workspace {
                    required property int modelData
                    wsId: modelData + 1 // Hyprland workspaces are 1 indexed
                    widgetWidth: root.width / (grid.columns + 0.5) 
                }
            }
        }
    }
}

